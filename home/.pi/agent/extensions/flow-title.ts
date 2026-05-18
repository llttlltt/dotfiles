import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import path from "node:path";

const RESET = "\x1b[0m";
const BOLD = "\x1b[1m";

// Controls how fast the gradient flows. Higher = faster.
const PHASE_SPEED = 0.3; // cycles per second
const FRAME_MS = 60; // ~12.5fps — smooth enough, easy on the terminal

const TITLE_LINES = [
  "  ██████╗  ██╗ ",
  "  ██╔══██╗ ██║ ",
  "  ██████╔╝ ██║ ",
  "  ██╔═══╝  ██║ ",
  "  ██║      ██║ ",
  "  ╚═╝      ╚═╝ ",
];

type Rgb = [number, number, number];

const TRUECOLOR_FG_PATTERN = /\x1b\[38;2;(\d+);(\d+);(\d+)m/;

let cachedPalette: { key: string; palette: Rgb[] } | undefined;

function mix(a: number, b: number, t: number) {
  return Math.round(a + (b - a) * t);
}

function clamp(value: number) {
  return Math.max(0, Math.min(255, Math.round(value)));
}

function extractAccent(ctx: ExtensionContext): Rgb {
  const sample = ctx.ui.theme.fg("accent", "x");
  const match = TRUECOLOR_FG_PATTERN.exec(sample);
  if (match) {
    return [Number(match[1]), Number(match[2]), Number(match[3])];
  }
  // Fallback if the theme isn't using truecolor
  return [48, 129, 247];
}

function shade([r, g, b]: Rgb, amount: number): Rgb {
  if (amount >= 0) {
    return [
      clamp(r + (255 - r) * amount),
      clamp(g + (255 - g) * amount),
      clamp(b + (255 - b) * amount),
    ];
  }
  const k = 1 + amount;
  return [clamp(r * k), clamp(g * k), clamp(b * k)];
}

function buildPalette(base: Rgb): Rgb[] {
  const deep = shade(base, -0.55);
  const mid = base;
  const light = shade(base, 0.4);
  const ice = shade(base, 0.75);
  return [deep, mid, light, ice, light, mid];
}

function getPalette(ctx: ExtensionContext): Rgb[] {
  const accent = extractAccent(ctx);
  const key = accent.join(",");
  if (cachedPalette?.key === key) return cachedPalette.palette;
  cachedPalette = { key, palette: buildPalette(accent) };
  return cachedPalette.palette;
}

function sampleGradient(palette: Rgb[], position: number) {
  const wrapped = ((position % 1) + 1) % 1;
  const scaled = wrapped * palette.length;
  const index = Math.floor(scaled);
  const nextIndex = (index + 1) % palette.length;
  const t = scaled - index;
  const a = palette[index]!;
  const b = palette[nextIndex]!;
  return [mix(a[0], b[0], t), mix(a[1], b[1], t), mix(a[2], b[2], t)] as Rgb;
}

function fg([r, g, b]: Rgb, text: string) {
  return `\x1b[38;2;${r};${g};${b}m${text}${RESET}`;
}

function gradientText(palette: Rgb[], text: string, phase: number) {
  const chars = [...text];
  const span = Math.max(chars.length - 1, 1);
  return chars
    .map((char, index) => {
      if (char === " ") return char;
      return fg(sampleGradient(palette, index / span + phase), char);
    })
    .join("");
}

function center(text: string, width: number) {
  const length = [...text].length;
  if (length >= width) return text;
  return `${" ".repeat(Math.floor((width - length) / 2))}${text}`;
}

function projectName() {
  return path.basename(process.cwd()) || "session";
}

function renderHeader(
  ctx: ExtensionContext,
  width: number,
  phase: number,
  subtitleText: string,
) {
  const palette = getPalette(ctx);
  const lines = TITLE_LINES.map((line, row) =>
    gradientText(palette, center(line, width), phase + row * 0.045),
  );
  const subtitle = center(subtitleText, width);

  return [
    "",
    ...lines,
    `${BOLD}${gradientText(palette, subtitle, phase + 0.18)}${RESET}`,
    "",
  ];
}

export default function (pi: ExtensionAPI) {
  let requestRender: (() => void) | undefined;
  let currentModelId = "no model selected";
  let animationTimer: ReturnType<typeof setInterval> | undefined;

  let startedAt = Date.now();
  let isAnimating = false;
  let finalPhase = 0; // The "frozen" phase when idle

  function currentPhase() {
    if (!isAnimating) return finalPhase;
    return ((Date.now() - startedAt) / 1000) * PHASE_SPEED;
  }

  function startAnimation(cycles = 1) {
    if (isAnimating) return;

    isAnimating = true;
    startedAt = Date.now();
    // We want to stop after 'cycles' full rotations from the current position
    const targetPhase = currentPhase() + cycles;

    animationTimer = setInterval(() => {
      const p = currentPhase();
      if (p >= targetPhase) {
        stopAnimation(targetPhase);
      }
      requestRender?.();
    }, FRAME_MS);
  }

  function stopAnimation(atPhase?: number) {
    if (animationTimer) {
      clearInterval(animationTimer);
      animationTimer = undefined;
    }
    isAnimating = false;
    if (atPhase !== undefined) {
      // Normalize phase to 0-1 so colors are consistent
      finalPhase = atPhase % 1;
    }
  }

  function installHeader(ctx: ExtensionContext) {
    ctx.ui.setHeader((tui) => {
      requestRender = () => tui.requestRender();
      // Run a cycle on install
      startAnimation(1);
      return {
        render(width: number) {
          return renderHeader(
            ctx,
            width,
            currentPhase(),
            `${currentModelId} · ${projectName()}`,
          );
        },
        invalidate() {
          tui.requestRender();
        },
      };
    });
  }

  pi.on("session_start", (_event, ctx) => {
    currentModelId = ctx.model?.id ?? "no model selected";
    if (!ctx.hasUI) return;
    installHeader(ctx);
  });

  pi.on("model_select", (event) => {
    currentModelId = event.model.id;
    // Update the text immediately without starting a full animation loop
    requestRender?.();
  });

  pi.on("session_shutdown", (_event, ctx) => {
    if (ctx.hasUI) ctx.ui.setHeader(undefined);
    stopAnimation();
    requestRender = undefined;
    cachedPalette = undefined;
  });

  pi.registerCommand("flow-title", {
    description: "Enable the blue flowing gradient session header",
    handler: async (_args, ctx) => {
      installHeader(ctx);
      ctx.ui.notify("Flow title enabled", "info");
    },
  });

  pi.registerCommand("flow-title-builtin", {
    description: "Restore pi's built-in header for this session",
    handler: async (_args, ctx) => {
      ctx.ui.setHeader(undefined);
      stopAnimation();
      ctx.ui.notify("Built-in header restored", "info");
    },
  });
}
