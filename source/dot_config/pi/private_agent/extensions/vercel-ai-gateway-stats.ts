import { AuthStorage, getSettingsListTheme, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Container, SettingsList, Text } from "@earendil-works/pi-tui";
import { join } from "node:path";
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "node:fs";
import { homedir } from "node:os";

// --- Types ---

interface PricingTier {
  min: number;
  max?: number;
  cost: string;
}

interface ModelPricing {
  input?: string;
  output?: string;
  input_tiers?: PricingTier[];
  output_tiers?: PricingTier[];
  input_cache_read?: string;
  input_cache_write?: string;
  image?: string;
  web_search?: string;
  maps_search?: string;
}

interface ModelInfo {
  id: string;
  pricing: ModelPricing;
}

interface ExtensionState {
  showBalance: boolean;
  showTotal: boolean;
  showInputPrice: boolean;
  showOutputPrice: boolean;
  showCacheReadPrice: boolean;
  showCacheWritePrice: boolean;
  showImagePrice: boolean;
  showWebSearchPrice: boolean;
  showMapsSearchPrice: boolean;
  precision: number;
  flashDuration: number;
}

// --- Constants ---

const ICONS = {
  balance: "\udb85\ude79",
  used: "\uede8",
  input: "↑",
  output: "↓",
  cache: "󰏖",
  image: "󰏔",
  webSearch: "󰖟",
  mapsSearch: "󰉬",
};

/**
 * Registry of metrics to simplify rendering and state tracking.
 * This data-driven approach allows for easy extension (OCP).
 */
const PRICING_METRICS = [
  { id: "i",   label: "IN",   icon: ICONS.input,    showKey: "showInputPrice",      mult: 1000000 },
  { id: "o",   label: "OUT",  icon: ICONS.output,   showKey: "showOutputPrice",     mult: 1000000 },
  { id: "cr",  label: "R",    icon: ICONS.cache,    showKey: "showCacheReadPrice",  mult: 1000000 },
  { id: "cw",  label: "W",    icon: ICONS.cache,    showKey: "showCacheWritePrice", mult: 1000000 },
  { id: "img", label: "IMG",  icon: ICONS.image,    showKey: "showImagePrice",      mult: 1 },
  { id: "ws",  label: "WEB",  icon: ICONS.webSearch, showKey: "showWebSearchPrice",   mult: 1 },
  { id: "ms",  label: "MAPS", icon: ICONS.mapsSearch, showKey: "showMapsSearchPrice",  mult: 1 },
] as const;

const COOLDOWN_MS = 10000;
const MODELS_REFRESH_MS = 3600000;

// --- Pure Logic Functions ---

const getTieredCost = (tiers: PricingTier[] | undefined, base: string | undefined, tokens: number): number => {
  if (!tiers || tiers.length === 0) return parseFloat(base || "0");
  const tier = tiers.find(t => tokens >= t.min && (t.max === undefined || tokens < t.max));
  return parseFloat(tier ? tier.cost : tiers[tiers.length - 1].cost);
};

/**
 * Extracts all pricing metrics for a specific model context.
 */
const calculateMetrics = (p: ModelPricing, tokens: number) => ({
  i: getTieredCost(p.input_tiers, p.input, tokens),
  o: getTieredCost(p.output_tiers, p.output, tokens),
  cr: parseFloat(p.input_cache_read || "0"),
  cw: parseFloat(p.input_cache_write || "0"),
  img: parseFloat(p.image || "0"),
  ws: parseFloat(p.web_search || "0"),
  ms: parseFloat(p.maps_search || "0"),
});

const formatCurrency = (val: number | undefined, mult: number, precision: number): string => {
  if (val === undefined) return "-.--";
  const scaled = val * mult;
  const formatted = parseFloat(scaled.toFixed(precision)).toString();
  return `$${formatted}${mult === 1 ? "/K" : "/M"}`;
};

// --- IO & Configuration ---

const CONFIG_DIR = join(homedir(), ".config", "pi", "agent", "extensions", "vercel-ai-gateway-stats");
const CONFIG_PATH = join(CONFIG_DIR, "settings.json");

const loadSettings = (): ExtensionState => {
  const defaults: ExtensionState = {
    showBalance: true,
    showTotal: true,
    showInputPrice: true,
    showOutputPrice: true,
    showCacheReadPrice: true,
    showCacheWritePrice: true,
    showImagePrice: false,
    showWebSearchPrice: false,
    showMapsSearchPrice: false,
    precision: 2,
    flashDuration: 1,
  };
  try {
    return existsSync(CONFIG_PATH) ? { ...defaults, ...JSON.parse(readFileSync(CONFIG_PATH, "utf-8")) } : defaults;
  } catch {
    return defaults;
  }
};

const saveSettings = (state: ExtensionState) => {
  try {
    if (!existsSync(CONFIG_DIR)) mkdirSync(CONFIG_DIR, { recursive: true });
    writeFileSync(CONFIG_PATH, JSON.stringify(state, null, 2));
  } catch {}
};

// --- Extension Entry Point ---

export default function (pi: ExtensionAPI) {
  // --- Encapsulated State ---
  let state = loadSettings();
  let models: ModelInfo[] = [];
  let credits = { balance: undefined as number | undefined, used: undefined as number | undefined };
  let lastPrices: Record<string, number> = {};
  let lastUpdate = 0;
  let lastModelsUpdate = 0;
  let flashTimeout: NodeJS.Timeout | undefined;
  let isUpdating = false;

  // --- Rendering Logic ---

  const renderStatus = (ctx: any, flashes: Record<string, "success" | "error" | "accent"> = {}) => {
    const { theme } = ctx.ui;
    const parts: string[] = [];

    const addPart = (show: boolean, icon: string, label: string, val: string, color?: string) => {
      if (!show) return;
      const lblStr = theme ? theme.fg("dim", `${icon} ${label}:`) : `${icon} ${label}:`;
      const valStr = color && theme ? theme.fg(color as any, val) : val;
      parts.push(`${lblStr} ${valStr}`);
    };

    // Balance & Usage
    if (state.showBalance) {
      const val = credits.balance !== undefined ? credits.balance.toFixed(state.precision) : "-.--";
      addPart(true, ICONS.balance, "BAL", `$${val}`, flashes.b);
    }
    if (state.showTotal) {
      const val = credits.used !== undefined ? credits.used.toFixed(state.precision) : "-.--";
      addPart(true, ICONS.used, "TOT", `$${val}`, flashes.u);
    }

    // Model-specific Pricing
    const pricing = models.find(m => m.id === ctx.model?.id)?.pricing;
    if (pricing) {
      const tokens = ctx.getContextUsage?.()?.tokens ?? 0;
      const metrics = calculateMetrics(pricing, tokens);

      PRICING_METRICS.forEach(m => {
        const val = (metrics as any)[m.id];
        const visible = (state as any)[m.showKey] && (val > 0 || m.id === "i" || m.id === "o");
        if (visible) {
          addPart(true, m.icon, m.label, formatCurrency(val, m.mult, state.precision), flashes[m.id]);
        }
      });
    }

    ctx.ui.setStatus("vercel-credits", parts.length ? parts.join("  ") : undefined);
  };

  const triggerFlash = (ctx: any, flashes: Record<string, any>) => {
    renderStatus(ctx, flashes);
    if (Object.keys(flashes).length > 0) {
      if (flashTimeout) clearTimeout(flashTimeout);
      flashTimeout = setTimeout(() => renderStatus(ctx), state.flashDuration * 1000);
    }
  };

  const clearFlash = () => {
    if (flashTimeout) clearTimeout(flashTimeout);
  };

  // --- API Side Effects ---

  const fetchModels = async () => {
    if (models.length > 0 && Date.now() - lastModelsUpdate < MODELS_REFRESH_MS) return;
    try {
      const key = await AuthStorage.create().getApiKey("vercel-ai-gateway");
      if (!key) return;
      const res = await fetch("https://ai-gateway.vercel.sh/v1/models", {
        headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
      });
      if (res.ok) {
        models = ((await res.json()) as { data: ModelInfo[] }).data;
        lastModelsUpdate = Date.now();
      }
    } catch {}
  };

  const fetchCredits = async (ctx: any, silent = true) => {
    if (isUpdating || (silent && Date.now() - lastUpdate < COOLDOWN_MS)) return;
    isUpdating = true;

    try {
      const key = await AuthStorage.create().getApiKey("vercel-ai-gateway");
      if (!key) {
        if (!silent) ctx.ui.notify("Vercel API key not found.", "warning");
        return;
      }

      await fetchModels();

      const res = await fetch("https://ai-gateway.vercel.sh/v1/credits", {
        headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
      });

      if (!res.ok) throw new Error(`API Error: ${res.status}`);

      const data = await res.json() as { balance: string; total_used: string };
      const newB = parseFloat(data.balance);
      const newU = parseFloat(data.total_used);

      const flashes: any = {};
      if (state.flashDuration > 0) {
        if (credits.balance !== undefined && newB.toFixed(state.precision) !== credits.balance.toFixed(state.precision)) {
          flashes.b = newB > credits.balance ? "success" : "error";
        }
        if (credits.used !== undefined && newU.toFixed(state.precision) !== credits.used.toFixed(state.precision)) {
          flashes.u = newU > credits.used ? "error" : "success";
        }
      }

      credits = { balance: newB, used: newU };
      lastUpdate = Date.now();
      triggerFlash(ctx, flashes);
      if (!silent) ctx.ui.notify("Credits updated.", "info");
    } catch (e: any) {
      if (!silent) ctx.ui.notify(e.message, "error");
    } finally {
      isUpdating = false;
    }
  };

  // --- Event Handlers ---

  pi.on("session_start", async (_, ctx) => {
    if (ctx.model?.provider === "vercel-ai-gateway") {
      await fetchModels();
      renderStatus(ctx);
      setTimeout(() => fetchCredits(ctx), 2000);
    } else {
      ctx.ui.setStatus("vercel-credits", undefined);
    }
  });

  pi.on("model_select", async (ev, ctx) => {
    if (ev.model.provider !== "vercel-ai-gateway") {
      ctx.ui.setStatus("vercel-credits", undefined);
      return;
    }

    await fetchModels();
    const pricing = models.find(m => m.id === ev.model.id)?.pricing;
    const tokens = ctx.getContextUsage?.()?.tokens ?? 0;

    if (pricing) {
      const current = calculateMetrics(pricing, tokens);
      const flashes: any = {};

      PRICING_METRICS.forEach(m => {
        const val = (current as any)[m.id];
        if (lastPrices[m.id] === undefined) {
          flashes[m.id] = "accent"; // Highlight flash on initial load
        } else if (val !== lastPrices[m.id]) {
          flashes[m.id] = val > lastPrices[m.id] ? "error" : "success";
        } else {
          flashes[m.id] = "accent"; // Highlight flash if price is same
        }
        lastPrices[m.id] = val;
      });
      triggerFlash(ctx, flashes);
    }
    fetchCredits(ctx);
  });

  pi.on("agent_end", (_, ctx) => {
    if (ctx.model?.provider === "vercel-ai-gateway") fetchCredits(ctx);
  });

  pi.on("session_shutdown", clearFlash);

  // --- Command Registration ---

  pi.registerCommand("vercel-ai-gateway-stats", {
    description: "Vercel AI Gateway Stats Settings",
    handler: async (_, ctx) => {
      const menuItems = [
        { id: "refresh", label: "Refresh Credits", currentValue: "now", values: ["now"] },
        { id: "showBalance", label: "Show Balance", currentValue: state.showBalance ? "on" : "off", values: ["on", "off"] },
        { id: "showTotal", label: "Show Total Used", currentValue: state.showTotal ? "on" : "off", values: ["on", "off"] },
        { id: "showInputPrice", label: "Show Input Price", currentValue: state.showInputPrice ? "on" : "off", values: ["on", "off"] },
        { id: "showOutputPrice", label: "Show Output Price", currentValue: state.showOutputPrice ? "on" : "off", values: ["on", "off"] },
        { id: "precision", label: "Decimal Places", currentValue: state.precision.toString(), values: ["2", "3", "4", "5", "8"] },
        { id: "flashDuration", label: "Flash Duration (s)", currentValue: state.flashDuration ? state.flashDuration.toString() : "off", values: ["off", "1", "2", "3", "5"] },
      ];

      await ctx.ui.custom((_tui, theme, _kb, done) => {
        const container = new Container();
        container.addChild(new Text(theme.fg("accent", theme.bold("Vercel Gateway Stats")), 1, 1));
        const list = new SettingsList(menuItems, menuItems.length + 2, getSettingsListTheme(), (id, val) => {
          if (id === "refresh") return fetchCredits(ctx, false);
          if (id === "precision") state.precision = parseInt(val, 10);
          else if (id === "flashDuration") state.flashDuration = val === "off" ? 0 : parseInt(val, 10);
          else (state as any)[id] = val === "on";

          saveSettings(state);
          renderStatus(ctx);
        }, () => done(undefined));
        container.addChild(list);
        return {
          render: (w) => container.render(w),
          handleInput: (d) => list.handleInput?.(d),
        };
      });
    },
  });
}
