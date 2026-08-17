# Vercel AI Gateway Stats

A Pi extension that displays your Vercel AI Gateway balance, total credits used, and real-time model pricing in the status bar.

## Features

- **Balance & Usage**: Real-time display of your remaining Vercel credits and total expenditure.
- **Context-Aware Pricing**: Automatically displays model pricing based on your current chat's token count.
- **Tiered Pricing Support**: Correcty handles models with context-based pricing tiers (e.g., Gemini, Claude).
- **Optional Pricing Chips**:
  - ↑ **IN**: Cost per 1M input tokens.
  - ↓ **OUT**: Cost per 1M output tokens.
  - 󰏖 **R**: Cost per 1M cached input tokens.
  - 󰏖 **W**: Cost per 1M input tokens (cache write).
  - 󰏔 **IMG**: Cost per generated image (per 1K).
  - 󰖟 **WEB**: Cost per web search request (per 1K).
  - 󰉬 **MAPS**: Cost per maps search request (per 1K).
- **Smart Filtering**: Pricing chips are automatically hidden if a model doesn't support the feature (e.g., no Image or Web search).
- **Flash Notifications**:
  - Balance/Usage: Visual feedback when your remaining credits or total spending changes.
  - Model Switch: Compare pricing between models instantly. Prices flash **red** if the new model is more expensive, **green** if cheaper. Applies to all metrics: Input, Output, Cache Read/Write, Image, Web Search, and Maps Search.
- **Customizable Precision**: Choose how many decimal places to display.

## Usage

### Model Price Comparison

When you switch models, the pricing metrics **flash** to show whether the new model is cheaper or more expensive:

- 🔵 **Accent flash**: Initial load or identical price
- 🟢 **Green flash**: New model is cheaper
- 🔴 **Red flash**: New model is more expensive

This applies to all displayed pricing chips, so you can instantly compare total costs across models.

## Configuration

Run `/vercel-ai-gateway-stats` to open the settings menu where you can:
- Toggle individual metrics on/off (Balance, Used, Input, Output, Cache Read/Write, Image, Web Search, Maps Search).
- Refresh credits manually.
- Set decimal precision (2–8 decimal places).
- Configure flash duration (off or 1–10 seconds).

## Authentication

The extension uses the `vercel-ai-gateway` API key from your `auth.json`. If not found, it will prompt you to provide one.
