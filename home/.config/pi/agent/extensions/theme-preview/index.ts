/* cspell:disable-file */
/**
 * Theme Preview Extension
 *
 * Renders actual Pi TUI components to visualize and develop themes.
 */

import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import {
	Box,
	Container,
	Key,
	matchesKey,
	Text,
	truncateToWidth,
} from "@earendil-works/pi-tui";

// ─── Types ────────────────────────────────────────────────────────────────────

type View = "showcase" | "palette" | "components";
type ThemeFgKey = Parameters<Theme["fg"]>[0];
type ThemeBgKey = Parameters<Theme["bg"]>[0];

interface ThemeItem<T extends ThemeFgKey | ThemeBgKey> {
	key: T;
	label: string;
}

const VIEWS: View[] = ["showcase", "palette", "components"];

// ─── Theme Registry ───────────────────────────────────────────────────────────

const PALETTE_GROUPS: Record<string, ThemeItem<ThemeFgKey>[]> = {
	General: [
		{ key: "text", label: "Text" },
		{ key: "accent", label: "Accent" },
		{ key: "muted", label: "Muted" },
		{ key: "dim", label: "Dim" },
	],
	Status: [
		{ key: "success", label: "Success" },
		{ key: "error", label: "Error" },
		{ key: "warning", label: "Warning" },
	],
	Borders: [
		{ key: "border", label: "Border" },
		{ key: "borderAccent", label: "Border Accent" },
		{ key: "borderMuted", label: "Border Muted" },
	],
	Messages: [
		{ key: "userMessageText", label: "User Text" },
		{ key: "customMessageText", label: "Custom Text" },
		{ key: "customMessageLabel", label: "Custom Label" },
	],
	Tools: [
		{ key: "toolTitle", label: "Tool Title" },
		{ key: "toolOutput", label: "Tool Output" },
	],
	Diffs: [
		{ key: "toolDiffAdded", label: "Added" },
		{ key: "toolDiffRemoved", label: "Removed" },
		{ key: "toolDiffContext", label: "Context" },
	],
	Markdown: [
		{ key: "mdHeading", label: "Heading" },
		{ key: "mdLink", label: "Link" },
		{ key: "mdLinkUrl", label: "Link URL" },
		{ key: "mdCode", label: "Inline Code" },
		{ key: "mdCodeBlock", label: "Code Block" },
		{ key: "mdCodeBlockBorder", label: "Code Block Border" },
		{ key: "mdQuote", label: "Block Quote" },
		{ key: "mdQuoteBorder", label: "Quote Border" },
		{ key: "mdHr", label: "Horizontal Rule" },
		{ key: "mdListBullet", label: "List Bullet" },
	],
	Syntax: [
		{ key: "syntaxKeyword", label: "Keyword" },
		{ key: "syntaxFunction", label: "Function" },
		{ key: "syntaxVariable", label: "Variable" },
		{ key: "syntaxString", label: "String" },
		{ key: "syntaxNumber", label: "Number" },
		{ key: "syntaxType", label: "Type" },
		{ key: "syntaxOperator", label: "Operator" },
		{ key: "syntaxPunctuation", label: "Punctuation" },
		{ key: "syntaxComment", label: "Comment" },
	],
	Thinking: [
		{ key: "thinkingText", label: "Thinking Text" },
		{ key: "thinkingOff", label: "Off" },
		{ key: "thinkingMinimal", label: "Minimal" },
		{ key: "thinkingLow", label: "Low" },
		{ key: "thinkingMedium", label: "Medium" },
		{ key: "thinkingHigh", label: "High" },
		{ key: "thinkingXhigh", label: "Max" },
	],
	Modes: [{ key: "bashMode", label: "Bash Mode" }],
};

const BACKGROUNDS: ThemeItem<ThemeBgKey>[] = [
	{ key: "selectedBg", label: "Selection" },
	{ key: "userMessageBg", label: "User Msg" },
	{ key: "customMessageBg", label: "Custom Msg" },
	{ key: "toolPendingBg", label: "Tool Pending" },
	{ key: "toolSuccessBg", label: "Tool Success" },
	{ key: "toolErrorBg", label: "Tool Error" },
];

const THINKING_LEVELS = PALETTE_GROUPS.Thinking.filter(
	(i) => i.key !== "thinkingText",
);

// ─── Helpers ──────────────────────────────────────────────────────────────────

const capitalize = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

/** Renders multiple stacked text lines inside a Box. */
function makeBox(
	width: number,
	px: number,
	py: number,
	lines: string[],
	bg?: (s: string) => string,
): string[] {
	const box = new Box(px, py, bg);
	const container = new Container();
	for (const line of lines) {
		container.addChild(new Text(line, 0, 0));
	}
	box.addChild(container);
	return box.render(width);
}

/** Renders lines inside a bare Box (no Container), preserving per-line padding. */
function makeBareBox(width: number, lines: string[]): string[] {
	const box = new Box(0, 0);
	for (const line of lines) {
		box.addChild(new Text(line, 1, 0));
	}
	return box.render(width);
}

// ─── View Renderers ───────────────────────────────────────────────────────────

function renderShowcase(width: number, theme: Theme): string[] {
	const separator = "";
	const fgRow = (items: ThemeItem<ThemeFgKey>[]) =>
		items.map((i) => theme.fg(i.key, `● ${i.label}`)).join("  ");

	return [
		// Core palette
		theme.fg("accent", theme.bold("[ Core Palette ]")),
		fgRow(PALETTE_GROUPS.General),
		fgRow(PALETTE_GROUPS.Status),
		separator,

		// Messages
		theme.fg("accent", theme.bold("[ Messages ]")),
		"",
		...makeBox(
			width,
			1,
			0,
			[theme.fg("userMessageText", "Is the theme rendering correctly?")],
			(s) => theme.bg("userMessageBg", s),
		),
		"",
		...makeBox(width, 1, 0, [
			theme.fg("text", "Yes — components and colors look great."),
		]),
		"",
		...makeBox(
			width,
			1,
			0,
			[
				theme.fg("customMessageLabel", "System: ") +
					theme.fg("customMessageText", "Ready to build."),
			],
			(s) => theme.bg("customMessageBg", s),
		),
		separator,

		// Tools
		theme.fg("accent", theme.bold("[ Tools ]")),
		"",
		...makeBox(
			width,
			1,
			1,
			[
				theme.fg("toolTitle", "✓ Build"),
				theme.fg("toolOutput", "  Completed in 1.2s"),
			],
			(s) => theme.bg("toolSuccessBg", s),
		),
		"",
		...makeBox(
			width,
			1,
			1,
			[
				theme.fg("toolTitle", "✗ Deploy"),
				theme.fg("toolOutput", "  Connection refused"),
			],
			(s) => theme.bg("toolErrorBg", s),
		),
		separator,

		// Status
		theme.fg("accent", theme.bold("[ Status ]")),
		[
			theme.fg("success", "✓ Success"),
			theme.fg("error", "✗ Error"),
			theme.fg("warning", "⚠ Warning"),
		].join("  "),
		separator,

		// Thinking
		theme.fg("accent", theme.bold("Thinking Levels")),
		THINKING_LEVELS.map((i) => theme.fg(i.key, `◆ ${i.label}`)).join("  "),
		separator,

		// Code
		theme.fg("accent", theme.bold("[ Code ]")),
		" " +
			[
				theme.fg("syntaxKeyword", "const"),
				theme.fg("syntaxVariable", "theme"),
				theme.fg("syntaxOperator", "="),
				theme.fg("syntaxString", '"beautiful"'),
			].join(" "),
		separator,

		// Markdown
		theme.fg("accent", theme.bold("[ Markdown ]")),
		[
			theme.fg("mdHeading", "# Title"),
			theme.fg("mdLink", "link"),
			theme.fg("mdCode", "`code`"),
			theme.fg("mdQuote", "> quote"),
		].join("  "),
		"",
	];
}

function renderPalette(width: number, theme: Theme): string[] {
	const lines: string[] = [];

	for (const [group, items] of Object.entries(PALETTE_GROUPS)) {
		lines.push(theme.fg("accent", theme.bold(`[ ${group} ]`)));
		for (const item of items) {
			try {
				lines.push(theme.fg(item.key, ` ${item.key.padEnd(22)} ${item.label}`));
			} catch {
				lines.push(theme.fg("dim", ` ${item.key} (unavailable)`));
			}
		}
		lines.push("");
	}

	lines.push(theme.fg("accent", theme.bold("[ Backgrounds ]")));
	for (const item of BACKGROUNDS) {
		try {
			lines.push(theme.bg(item.key, ` ${item.key.padEnd(22)} ${item.label}`));
		} catch {
			lines.push(theme.fg("dim", ` ${item.key} (unavailable)`));
		}
	}

	const total =
		Object.values(PALETTE_GROUPS).flat().length + BACKGROUNDS.length;
	lines.push("", theme.fg("dim", ` Total colors: ${total}`));

	return lines;
}

function renderComponents(width: number, theme: Theme): string[] {
	const section = (title: string) =>
		theme.fg("accent", theme.bold(`[ ${title} ]`));
	const lines: string[] = [];

	// 1. User Message
	lines.push(section("User Message"));
	lines.push(
		...makeBox(
			width,
			1,
			0,
			[
				theme.fg(
					"userMessageText",
					"You: Implement the theme preview component",
				),
			],
			(s) => theme.bg("userMessageBg", s),
		),
	);
	lines.push("");

	// 2. Assistant Message
	lines.push(section("Assistant Message"));
	lines.push(
		...makeBox(
			width,
			1,
			0,
			[
				theme.fg(
					"text",
					"Assistant: I'll create a component that shows all message types...",
				),
			],
			(s) => theme.bg("customMessageBg", s),
		),
	);
	lines.push("");

	// 3. Custom Message
	lines.push(section("Custom Message (System)"));
	lines.push(
		...makeBox(
			width,
			1,
			0,
			[
				theme.fg("customMessageLabel", "System: ") +
					theme.fg("customMessageText", "Operation completed successfully"),
			],
			(s) => theme.bg("customMessageBg", s),
		),
	);
	lines.push("");

	// 4. Bash Output
	lines.push(section("Bash Output"));
	lines.push(
		...makeBareBox(width, [
			theme.fg("dim", "$ ls -la .config/pi/agent/"),
			theme.fg("toolOutput", "drwxr-xr-x  15 user  staff   480 Jun 18 10:40 ."),
			theme.fg(
				"toolOutput",
				"drwxr-xr-x   3 user  staff    96 Jun 18 10:42 ..",
			),
			theme.fg(
				"toolOutput",
				"-rw-r--r--   1 user  staff  4096 Jun 18 10:42 prompts",
			),
		]),
	);
	lines.push("");

	// 5. Successful Tool
	lines.push(section("Successful Tool"));
	lines.push(
		...makeBox(
			width,
			1,
			1,
			[
				theme.fg("toolTitle", "✓ read ./prompts/theme-preview.md"),
				theme.fg("toolOutput", "  └─ Successfully read 156 bytes"),
			],
			(s) => theme.bg("toolSuccessBg", s),
		),
	);
	lines.push("");

	// 6. Failing Tool
	lines.push(section("Failing Tool"));
	lines.push(
		...makeBox(
			width,
			1,
			1,
			[
				theme.fg("toolTitle", "✗ read ./nonexistent/file.md"),
				theme.fg("toolOutput", "  └─ ENOENT: no such file or directory"),
			],
			(s) => theme.bg("toolErrorBg", s),
		),
	);
	lines.push("");

	// 7. Markdown Elements
	lines.push(section("Markdown Elements"));
	lines.push(
		...makeBox(width, 1, 0, [
			theme.fg("mdHeading", theme.bold("# Heading")) +
				" with " +
				theme.fg("mdLink", "link") +
				" " +
				theme.fg("mdLinkUrl", "(url)"),
			theme.fg("mdCode", "`code`") +
				" | " +
				theme.fg("mdQuote", "> quote") +
				" | " +
				theme.fg("mdHr", "─"),
		]),
	);
	lines.push("");

	// 8. Syntax Highlighting
	lines.push(section("Syntax Highlighting"));
	lines.push(
		...makeBareBox(width, [
			[
				theme.fg("syntaxKeyword", "const"),
				theme.fg("syntaxVariable", "x"),
				theme.fg("syntaxOperator", "="),
				theme.fg("syntaxNumber", "42"),
			].join(" "),
			theme.fg("syntaxComment", "// comment") +
				" vs " +
				theme.fg("syntaxString", '"string"'),
			[
				theme.fg("syntaxKeyword", "function"),
				theme.fg("syntaxFunction", "render") +
					theme.fg("syntaxPunctuation", "(") +
					theme.fg("syntaxType", "Theme") +
					theme.fg("syntaxPunctuation", ")"),
			].join(" "),
		]),
	);
	lines.push("");

	// 9. Diff Colors
	lines.push(section("Diff Colors"));
	lines.push(
		...makeBox(width, 1, 0, [
			theme.fg("toolDiffAdded", "+ added line"),
			theme.fg("toolDiffRemoved", "- removed line"),
			theme.fg("toolDiffContext", "  context line"),
		]),
	);
	lines.push("");

	// 10. Thinking Levels
	lines.push(section("Thinking Levels"));
	for (const item of THINKING_LEVELS) {
		lines.push(
			"  " +
				theme.fg(item.key, "●") +
				" " +
				theme.fg(item.key, item.label.padEnd(10)),
		);
	}
	lines.push("");

	// 11. Borders & Status
	lines.push(section("Borders & Status"));
	lines.push(
		"  " +
			[
				theme.fg("border", "border"),
				theme.fg("borderAccent", "borderAccent"),
				theme.fg("borderMuted", "borderMuted"),
			].join(" | "),
	);
	lines.push("");

	return lines;
}

// ─── Component Logic ──────────────────────────────────────────────────────────

class ThemePreviewComponent {
	private view: View = "showcase";

	handleInput(data: string) {
		if (matchesKey(data, Key.tab)) {
			const idx = VIEWS.indexOf(this.view);
			this.view = VIEWS[(idx + 1) % VIEWS.length];
		}
	}

	render(width: number, theme: Theme): string[] {
		const header = [
			VIEWS.map((v) =>
				v === this.view
					? theme.bg("selectedBg", theme.fg("accent", ` ${capitalize(v)} `))
					: theme.fg("dim", ` ${capitalize(v)} `),
			).join(theme.fg("borderMuted", "│")) +
				theme.fg("dim", "  TAB: cycle  ESC: close"),
			theme.fg("borderMuted", "─".repeat(width)),
			"",
		];

		const content = (() => {
			switch (this.view) {
				case "palette":
					return renderPalette(width, theme);
				case "components":
					return renderComponents(width, theme);
				default:
					return renderShowcase(width, theme);
			}
		})();

		return [...header, ...content];
	}
}

// ─── Extension Entry ──────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
	pi.registerCommand("theme-preview", {
		description: "Preview themes with unified data structures",
		handler: async (_args, ctx) => {
			const preview = new ThemePreviewComponent();
			await ctx.ui.custom((_tui, theme, _kb, done) => ({
				render: (w) =>
					preview.render(w, theme).map((l) => truncateToWidth(l, w, "")),
				handleInput: (d) => {
					if (matchesKey(d, Key.escape)) {
						done(undefined);
						return;
					}
					preview.handleInput(d);
					_tui.requestRender();
				},
				invalidate: () => {},
			}));
		},
	});
}
