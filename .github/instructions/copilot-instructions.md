---
name: 'ZwiftScripts-Repo-Instructions'
description: 'Use when working in this ZwiftScripts repo: PowerShell automation, MonitorZwift scripts/config/module/tests, Sauce mod folders, GitHub workflows, site files, and Windows launcher shortcuts.'
applyTo: '**'
---

<instructions>
  <role>

## Repository Role and Default Assumptions

- This repository is **Windows-first** and is primarily a **PowerShell automation repo** for Zwift workflows, with some front-end Sauce mod files and GitHub Pages/workflow files.
- Do **not** treat this as a generic Node/TypeScript/ESLint-plugin repository just because the workspace may expose an `npm: compile` task.
- Prefer solutions that preserve the user's real Windows setup: PowerShell, COM automation, `.lnk` shortcuts, OBS WebSocket, DisplayConfig, PowerToys, Spotify, Explorer, and absolute Windows paths.

  </role>

  <repo_map>

## Repository Map

- **Root PowerShell automation**
  - `MonitorZwift.ps1` → modern entrypoint
  - `MonitorZwift.config.json` → runtime configuration/source of truth for paths, displays, OBS, browser, logging, etc.
  - `MonitorZwift-v2.ps1` → legacy all-in-one script, often used as the behavior baseline
  - `LaunchZwift.ps1`, `MoveZwiftCleanPhotos.ps1`, `SetPrimaryDefault.ps1`, `SetPrimaryZwift.ps1`
- **Modern automation module**
  - `modules/ZwiftScripts.Automation/**`
  - Keep orchestration logic here when evolving the modern flow.
- **Tests**
  - `tests/*.ps1`
  - Pester tests and focused script validation live here.
- **Sauce / UI mod content**
  - `sauce4zwift-mod-tippy/**`
  - HTML/CSS/JS/manifest/settings pages for Sauce-related mods.
- **Repo/site automation**
  - `.github/workflows/**`, `.github/*.yml`, `_config.yml`, `sitemap.xml`, `file_list.md`, `filelist.html`, `README.md`

### Multi-folder workspace note

- The VS Code workspace may also include external mirror folders outside this repo, such as Dropbox copies or other Sauce mod collections.
- Unless the user explicitly asks to update mirrored copies too, treat **this repo** (`c:\Users\Nick\Dropbox\PC (2)\Documents\GitHub\ZwiftScripts`) as the source of truth.

  </repo_map>

  <editing_rules>

## Editing Rules

- Read before editing, then update existing files in place.
- Prefer the **modern MonitorZwift stack** for new behavior:
  - `MonitorZwift.ps1`
  - `MonitorZwift.config.json`
  - `modules/ZwiftScripts.Automation/**`
- Use `MonitorZwift-v2.ps1` mainly for:
  - bug-for-bug behavior comparison
  - parity work requested by the user
  - legacy-only fixes when the user still runs v2
- Keep the entrypoint thin and the module responsible for orchestration.
- Treat `MonitorZwift.config.json` as the source of truth for user-specific runtime settings.
- Preserve machine-specific paths and Windows assumptions unless the user asks to generalize them.
- Avoid broad refactors in the automation scripts unless they are necessary for reliability or parity.

### Shortcuts and binary files

- Do not try to hand-edit `.lnk` files as text.
- If shortcut updates are requested, use Windows shortcut automation (for example `WScript.Shell`) to update or recreate them.
- Do not edit logs, generated sync databases, or other binary/generated artifacts unless explicitly asked.

  </editing_rules>

  <powershell_guidance>

## PowerShell Guidance

- Prefer defensive, explicit PowerShell over clever shortcuts.
- Maintain compatibility with Windows PowerShell 5.1 where practical.
- Keep cleanup logic in `try/finally` when working on long-running orchestration flows.
- Preserve or improve existing logging rather than silently changing behavior.
- For Windows automation:
  - be careful with COM usage
  - quote paths with spaces correctly
  - assume GUI timing/focus issues are real and code defensively
- Respect display-index conventions already documented in the repo: config display indices are **0-based**.

  </powershell_guidance>

  <folder_specific_guidance>

## Folder-Specific Guidance

### `modules/ZwiftScripts.Automation/**`

- This is the preferred home for modern Zwift orchestration behavior.
- Keep helper functions reusable and side effects obvious.
- When adding behavior for parity with v2, prefer small helpers plus clear logging.

### `tests/**`

- Add or update targeted Pester coverage for behavior changes when practical.
- Favor focused regression tests for helpers over giant end-to-end rewrites.

### `sauce4zwift-mod-tippy/**` and other mod folders

- Keep `manifest.json`, page files, settings pages, and source modules aligned.
- Preserve existing naming/layout conventions instead of imposing a new app structure.

### `.github/workflows/**` and site files

- Keep YAML, Markdown, and site config changes minimal and syntactically valid.
- Avoid unnecessary edits to generated site/list outputs unless the user explicitly wants them regenerated.

  </folder_specific_guidance>

  <validation>

## Validation Expectations

- After editing PowerShell files (`.ps1`, `.psm1`, `.psd1`), run a PowerShell parser validation.
- After editing JSON, validate with `ConvertFrom-Json`.
- When touching tested logic, run the most relevant Pester test file(s) rather than unrelated tasks.
- Prefer targeted validation for this repo over generic `npm` workflows unless the changed files actually depend on them.
- If you change workflow or YAML files, keep syntax valid and consistent with existing GitHub Actions patterns.

  </validation>

  <quality_bar>

## Quality Bar

- Preserve working user behavior unless the request is specifically to modernize or change it.
- If the user asks for “same behavior as the old script,” treat `MonitorZwift-v2.ps1` as the behavioral baseline and call out any intentional differences.
- Favor reliability over novelty for GUI automation.
- Match existing repo conventions for logging, naming, and config-driven behavior.
- Be explicit when a request might require updating both this repo and an external mirrored copy.

  </quality_bar>
  </instructions>
