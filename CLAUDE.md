# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ai-bijo is a static web application portfolio hosted on GitHub Pages. It contains interactive web apps (calendar, english-words) and a script for generating anime character images via the OpenAI API.

- **Live site**: https://wasabina67.is-a.dev/ai-bijo/
- **Hosting**: GitHub Pages serving from the `docs/` directory on the `main` branch

## Architecture

```
docs/               → Static site root (served by GitHub Pages)
  index.html        → Landing page linking to apps
  calendar/         → Calendar app (vanilla JS, fully functional)
    index.html, script.js, style.css, favicon.svg
  english-words/    → English words app (vanilla JS, fully functional)
    index.html, script.js, style.css, data.json, favicon.svg
  images/           → Generated anime character JPEG images (1.jpg-50.jpg)
run.sh              → Image generation script using OpenAI API (gpt-image-1.5)
.env                → OPENAI_API_KEY (not committed)
.env.example        → Template for environment variables
```

All web apps use vanilla HTML/CSS/JS with no frameworks, no build tools, and no package manager. The apps share a glassmorphism UI style and randomly select a background image from `docs/images/`. The english-words app uses `data.json` to store vocabulary data.

## Commands

### Generate an image
```bash
bash run.sh
```
Requires `curl`, `jq`, and `OPENAI_API_KEY` in `.env` (use `.env.example` as template). Uses OpenAI's `gpt-image-1.5` model to generate anime character images with random backgrounds from famous landmarks. Outputs to `docs/images/output_YYYYMMDD_HHMMSS.jpg`.

### Deploy
Push to `main` branch — GitHub Pages deploys automatically from `docs/`.

### Local preview
Open `docs/index.html` directly in a browser. No dev server needed.
