# Theme Preview Extension

Live theme component previewer for developing and testing Pi themes. Shows **all 46+ theme colors** and how they render in real TUI components.

**Three views:** Components (detailed), Palette (reference), and Showcase (screenshot-friendly).

## Features

### Showcase View (Default - First)
Beautiful overview designed for screenshots and sharing:
- Framed header with theme name
- Primary colors highlight
- Message examples (user, assistant, system)
- Tool examples (success, error)
- Status indicators
- Thinking level spectrum
- Code and markdown samples
- Elegant footer with navigation

**Perfect for:** Sharing themes, documentation, portfolios

### Palette View (Reference - Second)
Comprehensive color palette organized by category:
- **General** - text, accent, muted, dim
- **Status** - success, error, warning
- **Borders** - border, borderAccent, borderMuted
- **Messages** - userMessageText, customMessageText, customMessageLabel
- **Tools** - toolTitle, toolOutput
- **Diffs** - toolDiffAdded, toolDiffRemoved, toolDiffContext
- **Markdown** - 10 colors
- **Syntax Highlighting** - 9 colors
- **Thinking Mode** - 7 colors
- **Backgrounds** - 6 colors
- **Modes** - bashMode

**Total: 46+ colors with full names**

### Components View (Detailed - Third)
Renders 11 real-world component examples showing all colors in context:
1. **User Message** - userMessageBg, userMessageText
2. **Assistant Message** - text
3. **Custom/System Message** - customMessageBg, customMessageText, customMessageLabel
4. **Bash Output** - dim, toolOutput
5. **Successful Tool** - toolSuccessBg, toolTitle, toolOutput
6. **Failing Tool** - toolErrorBg, toolTitle, toolOutput
7. **Markdown Elements** - mdHeading, mdLink, mdCode, mdQuote, mdHr
8. **Syntax Highlighting** - 9 syntax colors
9. **Diff Colors** - toolDiffAdded, toolDiffRemoved, toolDiffContext
10. **Thinking Levels** - 6 thinking levels (off, minimal, low, medium, high, xhigh)
11. **Borders & Status** - border, borderAccent, borderMuted



## Usage

```
/theme-preview
```

Then:
- **TAB**: Cycle through views (Showcase → Palette → Components → Showcase)
- **ESC**: Close the preview

**View Order:**
1. **Showcase** (default) - Beautiful overview for screenshots
2. **Palette** - Full color reference with names
3. **Components** - Detailed breakdown of all color usages

## How It Works

The extension uses **actual** Pi TUI components (`Text`, `Box`, `Container`) and renders them with your **real** theme colors. This means:

- What you preview is exactly what will appear in Pi's UI
- Colors are rendered in real component contexts
- Changes to your theme appear instantly (after Pi restart)
- No color approximations or separate test files

## Theme Development Workflow

1. Run `/theme-preview` to see the **Showcase** first
2. Press **TAB** to see the **Palette** reference
3. Press **TAB** again for **Components** detailed view
4. Edit your theme file (e.g., `~/.pi/agent/themes/my-theme.json`)
5. Restart Pi to reload the theme
6. Return to `/theme-preview` to verify changes
7. Iterate until satisfied

## Example Theme Schema

```json
{
  "name": "my-theme",
  "colors": {
    "accent": "#00ff88",
    "success": "#00cc66",
    "error": "#ff0044",
    "warning": "#ffaa00",
    "muted": "#999999",
    "dim": "#666666",
    "text": "#ffffff",
    "border": "#444444",
    "borderAccent": "#00ff88",
    "borderMuted": "#666666",
    "selectedBg": "#1a3a2a",
    "userMessageBg": "#001a0f",
    "userMessageText": "#00ff88",
    "customMessageBg": "#0f1a2a",
    "customMessageText": "#66ccff",
    "customMessageLabel": "#ffffff",
    "toolPendingBg": "#1a1a1a",
    "toolSuccessBg": "#0a2015",
    "toolErrorBg": "#2a0a10",
    "toolTitle": "#ffffff",
    "toolOutput": "#cccccc",
    "mdHeading": "#ffffff",
    "mdLink": "#00ff88",
    "mdLinkUrl": "#00ff88",
    "mdCode": "#ffffff",
    "mdCodeBlock": "#cccccc",
    "mdCodeBlockBorder": "#444444",
    "mdQuote": "#6699ff",
    "mdQuoteBorder": "#334499",
    "mdHr": "#333333",
    "mdListBullet": "#555555",
    "toolDiffAdded": "#00cc66",
    "toolDiffRemoved": "#ff0044",
    "toolDiffContext": "#cccccc",
    "syntaxComment": "#666666",
    "syntaxKeyword": "#6699ff",
    "syntaxFunction": "#99ccff",
    "syntaxVariable": "#ffffff",
    "syntaxString": "#00ff88",
    "syntaxNumber": "#00ff88",
    "syntaxType": "#ffffff",
    "syntaxOperator": "#00ff88",
    "syntaxPunctuation": "#666666",
    "thinkingText": "#999999",
    "thinkingOff": "#444444",
    "thinkingMinimal": "#6699ff",
    "thinkingLow": "#6699ff",
    "thinkingMedium": "#00ff88",
    "thinkingHigh": "#ffaa00",
    "thinkingXhigh": "#ff0044",
    "bashMode": "#00ff88"
  }
}
```

## Sharing Themes

The **Showcase view** appears first, perfect for documenting and sharing themes:

```bash
# Take a screenshot
/theme-preview
# Default view is Showcase - screenshot directly!
```

## Publishing

This extension is structured for npm publishing:

```bash
npm publish
```

Users can install with:

```bash
pi install pi-theme-preview
```

## Source

- Location: `~/.config/pi/agent/extensions/theme-preview/`
- Type: Pi Extension (TypeScript)
- Command: `/theme-preview`
- Dependencies: Pi TUI components (built-in)
- Package: `pi-theme-preview` (npm)
