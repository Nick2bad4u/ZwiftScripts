# ZwiftScripts

A repo for holding various Zwift scripts, mods, etc

## MonitorZwift (modern / recommended)

The repo now includes a **modernized** Zwift session orchestrator with:

- **Preflight validation** (mandatory vs optional dependencies)
- **Timeouts everywhere** (no infinite hangs)
- **try/finally cleanup** (primary display, transparency, PowerToys Awake)
- **Structured logging** (transcript; optional JSONL)
- **OBS control via obs-websocket (optional)** (no focus/SendKeys)

### Files

- Entrypoint: `MonitorZwift.ps1`
- Config: `MonitorZwift.config.json`
- Module: `modules/ZwiftScripts.Automation/`
- Logs: `./logs/`

### Run

```powershell
cd path\to\ZwiftScripts
.\MonitorZwift.ps1
```

### Configuration notes

- All display indices in `MonitorZwift.config.json` are **0-based**.
    - Example: `ZwiftDisplayIndex: 3` means the **4th** Windows display.
- OBS WebSocket (OBS 28+):
    1) Enable **Tools > obs-websocket Settings > Enable WebSocket server**
    2) Set `OBS.WebSocket.Enabled = true`
    3) Set host/port/password in the config

### Legacy

`MonitorZwift-v2.ps1` remains in the repo as the legacy all-in-one script.

[![ActionLint](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/ActionLint.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/ActionLint.yml)
[![Dependency Review](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/dependency-review.yml)
[![Deploy static content to Pages](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/static.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/static.yml)
[![GitHub Pages - Generate XML sitemap](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/sitemap.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/sitemap.yml)
[![Greetings](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/greetings.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/greetings.yml)
[![Labeler](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/label.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/label.yml)
[![Lint Code Base](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/super-linter.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/super-linter.yml)
[![Mark stale issues and pull requests](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/stale.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/stale.yml)
[![Microsoft Defender for DevOps](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/defender.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/defender.yml)
[![OSSAR](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/ossar.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/ossar.yml)
[![OSV-Scanner](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/osv-scanner.yml/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/osv-scanner.yml)
[![pages-build-deployment](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/Nick2bad4u/ZwiftScripts/actions/workflows/pages/pages-build-deployment)

![Alt](https://repobeats.axiom.co/api/embed/4b2f7d665ac02f970e3e937dfe43bd14fd6b4b8e.svg "Repobeats analytics image")
<!-- FILE_LIST_START -->
<h1>## File List</h1>

<p># Here is a list of files included in this repository:</p>

<div class="lazyload-placeholder" data-content="file-list-1" style="min-height: 400px;"></div>
<div class="lazyload-placeholder" data-content="file-list-2" style="min-height: 400px;"></div>
<div class="lazyload-placeholder" data-content="file-list-3" style="min-height: 400px;"></div>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const lazyLoadElements = document.querySelectorAll('.lazyload-placeholder');

    if ("IntersectionObserver" in window) {
        let rootMargin = '0px 0px 400px 0px';
        let threshold = 0.5;
        if (window.innerWidth <= 768) {  // Mobile devices
            rootMargin = '0px 0px 100px 0px';
            threshold = 0.1;
        } else if (window.innerWidth <= 1024) {  // Tablets
            rootMargin = '0px 0px 200px 0px';
            threshold = 0.3;
        } else if (window.innerWidth <= 1440) {  // Small desktops
            rootMargin = '0px 0px 300px 0px';
            threshold = 0.4;
        } else {  // Large desktops
            rootMargin = '0px 0px 400px 0px';
            threshold = 0.5;
        }
        let observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    let placeholder = entry.target;
                    let contentId = placeholder.dataset.content;
                    let file_list_html = '';
                    switch(contentId) {
                        case 'file-list-1':
                            file_list_html = `<ul><h2 style="color: #f1841b;">Repo Root</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.black" style="color: #a6de03;">.black</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.editorconfig" style="color: #4bc38e;">.editorconfig</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.gitignore" style="color: #69a1e0;">.gitignore</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.hintrc" style="color: #c7b131;">.hintrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.jsbeautifyrc" style="color: #86b46e;">.jsbeautifyrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.jscsrc" style="color: #75d458;">.jscsrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.pre-commit-config.yaml" style="color: #c9a244;">.pre-commit-config.yaml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.pre-commit-hooks.yaml" style="color: #65d007;">.pre-commit-hooks.yaml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.prettierignore" style="color: #6e921e;">.prettierignore</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.prettierrc" style="color: #7cc17e;">.prettierrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.stylelintrc.json" style="color: #f7a388;">.stylelintrc.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vale.ini" style="color: #31eef7;">.vale.ini</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/CNAME" style="color: #df8a0d;">CNAME</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/LaunchZwift.ps1" style="color: #8ccd0e;">LaunchZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift-v2.md" style="color: #9b88ba;">MonitorZwift-v2.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift-v2.ps1" style="color: #4eca52;">MonitorZwift-v2.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift-v2.ps1%20-%20Shortcut.lnk" style="color: #eab914;">MonitorZwift-v2.ps1 - Shortcut.lnk</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift.ps1" style="color: #74daf2;">MonitorZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MoveZwiftCleanPhotos.ps1" style="color: #c68a75;">MoveZwiftCleanPhotos.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/README.md" style="color: #51f10a;">README.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/SetPrimaryDefault.ps1" style="color: #80b680;">SetPrimaryDefault.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/SetPrimaryZwift.ps1" style="color: #d69e0f;">SetPrimaryZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/Zwift-Bike-Combos.xlsx" style="color: #98a9ac;">Zwift-Bike-Combos.xlsx</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/Zwift-Setup.lnk" style="color: #d0ad42;">Zwift-Setup.lnk</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/ZwiftSetup.lnk" style="color: #58b43e;">ZwiftSetup.lnk</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/file_list.md" style="color: #879f3a;">file_list.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/filelist.html" style="color: #aea542;">filelist.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/filelist.md" style="color: #fea16c;">filelist.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sitemap.xml" style="color: #bbb19d;">sitemap.xml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/test.ps1" style="color: #b98c9e;">test.ps1</a></li>
<h2 style="color: #f68c9a;">CSS</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/css/DSNotes.css" style="color: #7fa6b6;">sauce4zwift-mod-tippy/pages/css/DSNotes.css</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/css/ui.css" style="color: #e1b534;">sauce4zwift-mod-tippy/pages/css/ui.css</a></li>
<h2 style="color: #b38251;">JavaScript</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.eslintrc.js" style="color: #41ddbf;">.eslintrc.js</a></li>
<h2 style="color: #24a28b;">YAML</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/dependabot.yml" style="color: #a283cb;">.github/dependabot.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/labeler.yml" style="color: #71aba2;">.github/labeler.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/ActionLint.yml" style="color: #a8af7b;">.github/workflows/ActionLint.yml</a></li></ul>`;
                            break;
                        case 'file-list-2':
                            file_list_html = `<ul><li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/codeql.yml" style="color: #e691b3;">.github/workflows/codeql.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/defender.yml" style="color: #43b989;">.github/workflows/defender.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/dependency-review.yml" style="color: #46d00e;">.github/workflows/dependency-review.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/generate-file-list.yml" style="color: #c1c183;">.github/workflows/generate-file-list.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/greetings.yml" style="color: #88e700;">.github/workflows/greetings.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/jekyll-gh-pages.yml" style="color: #de6f22;">.github/workflows/jekyll-gh-pages.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/label.yml" style="color: #7dcc88;">.github/workflows/label.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/ossar.yml" style="color: #ce74ff;">.github/workflows/ossar.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/osv-scanner.yml" style="color: #2cbb63;">.github/workflows/osv-scanner.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/scorecards.yml" style="color: #70c528;">.github/workflows/scorecards.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/sitemap.yml" style="color: #8fbd72;">.github/workflows/sitemap.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/stale.yml" style="color: #54e841;">.github/workflows/stale.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/static.yml" style="color: #ad77ca;">.github/workflows/static.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/super-linter.yml" style="color: #47abac;">.github/workflows/super-linter.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.markdownlint.yml" style="color: #fbba2b;">.markdownlint.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.scss-lint.yml" style="color: #5ad63a;">.scss-lint.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/_config.yml" style="color: #f97d7b;">_config.yml</a></li>
<h2 style="color: #769111;">.vscode</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/generate_file_list.py" style="color: #98850e;">.vscode/generate_file_list.py</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/launch.json" style="color: #b4b83d;">.vscode/launch.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/settings.json" style="color: #2ca19d;">.vscode/settings.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/tasks.json" style="color: #4ff64c;">.vscode/tasks.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/test_generate_file_list.py" style="color: #6beb00;">.vscode/test_generate_file_list.py</a></li>
<h2 style="color: #74955f;">sauce4zwift-mod-tippy</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/.gitignore" style="color: #9a9e62;">sauce4zwift-mod-tippy/.gitignore</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/Change%20Log.txt" style="color: #28aaa1;">sauce4zwift-mod-tippy/Change Log.txt</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/LICENSE" style="color: #3ee866;">sauce4zwift-mod-tippy/LICENSE</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/README.md" style="color: #dea139;">sauce4zwift-mod-tippy/README.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/manifest.json" style="color: #72c41c;">sauce4zwift-mod-tippy/manifest.json</a></li>
<h2 style="color: #8fba73;">sauce4zwift-mod-tippy/pages</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/DSNotes.html" style="color: #9da660;">sauce4zwift-mod-tippy/pages/DSNotes.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/chaseRace.html" style="color: #54ccca;">sauce4zwift-mod-tippy/pages/chaseRace.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/estimatedCalories.html" style="color: #4aad38;">sauce4zwift-mod-tippy/pages/estimatedCalories.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/estimatedFinish-v1.html" style="color: #bc9d18;">sauce4zwift-mod-tippy/pages/estimatedFinish-v1.html</a></li>
<h2 style="color: #b07a85;">sauce4zwift-mod-tippy/pages/images</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/checker_640.png" style="color: #dc8f03;">sauce4zwift-mod-tippy/pages/images/checker_640.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/greenConnect.png" style="color: #a0a924;">sauce4zwift-mod-tippy/pages/images/greenConnect.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/orangeConnect.png" style="color: #6a95fe;">sauce4zwift-mod-tippy/pages/images/orangeConnect.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/redConnect.png" style="color: #7bb70e;">sauce4zwift-mod-tippy/pages/images/redConnect.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/whiteConnect.png" style="color: #76a387;">sauce4zwift-mod-tippy/pages/images/whiteConnect.png</a></li></ul>`;
                            break;
                        case 'file-list-3':
                            file_list_html = `<ul><h2 style="color: #37b418;">sauce4zwift-mod-tippy/pages/settings</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/settings/DSNotes.html" style="color: #e9a5f5;">sauce4zwift-mod-tippy/pages/settings/DSNotes.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/settings/estimatedFinish.html" style="color: #60dbcc;">sauce4zwift-mod-tippy/pages/settings/estimatedFinish.html</a></li>
<h2 style="color: #41afea;">sauce4zwift-mod-tippy/pages/src</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/DSNotes.mjs" style="color: #f690f4;">sauce4zwift-mod-tippy/pages/src/DSNotes.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/chaseRace.mjs" style="color: #708896;">sauce4zwift-mod-tippy/pages/src/chaseRace.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/estimatedFinish.mjs" style="color: #3593b2;">sauce4zwift-mod-tippy/pages/src/estimatedFinish.mjs</a></li>
<h2 style="color: #6ce349;">sauce4zwift-mod-tippy/pages/src/BM</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/common.mjs" style="color: #d66a8a;">sauce4zwift-mod-tippy/pages/src/BM/common.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/dataLookup.mjs" style="color: #62c1f4;">sauce4zwift-mod-tippy/pages/src/BM/dataLookup.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/notesLookup.mjs" style="color: #dd7cd9;">sauce4zwift-mod-tippy/pages/src/BM/notesLookup.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/settings.mjs" style="color: #7cab98;">sauce4zwift-mod-tippy/pages/src/BM/settings.mjs</a></li>
<h2 style="color: #d7b95e;">sauce4zwift-mod-tippy/src</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/src/estimatedCalories.mjs" style="color: #5db917;">sauce4zwift-mod-tippy/src/estimatedCalories.mjs</a></li>
<h2 style="color: #66aff2;">src</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/src/generate_file_list.py" style="color: #2fe4ec;">src/generate_file_list.py</a></li>
<h2 style="color: #9eb30c;">tests</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/MonitorZwift-v2.Tests.ps1" style="color: #bd7f08;">tests/MonitorZwift-v2.Tests.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/test_OBSActivateAndRecord.ps1" style="color: #f15eed;">tests/test_OBSActivateAndRecord.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_LaunchZwift.ps1" style="color: #e05bff;">tests/tests_LaunchZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_MoveZwiftCleanPhotos.ps1" style="color: #52ec42;">tests/tests_MoveZwiftCleanPhotos.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_PowerToysAwake.ps1" style="color: #57b2c3;">tests/tests_PowerToysAwake.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_SetPrimaryDefault.ps1" style="color: #7396dc;">tests/tests_SetPrimaryDefault.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_SetPrimaryZwift.ps1" style="color: #e7a9b4;">tests/tests_SetPrimaryZwift.ps1</a></li>
<h2 style="color: #b3a5d8;">tests/old</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/old/tests_MonitorZwift-v2_3.ps1" style="color: #46b200;">tests/old/tests_MonitorZwift-v2_3.ps1</a></li></ul>`;
                            break;
                    }
                    placeholder.innerHTML = file_list_html;
                    observer.unobserve(placeholder);
                    console.log(`Loaded content for ${contentId}`);
                }
            });
        }, { rootMargin: rootMargin, threshold: threshold });

        lazyLoadElements.forEach(element => {
            element.style.marginTop = '-17px';
            observer.observe(element);
        });
    } else {
        lazyLoadElements.forEach(placeholder => {
            let contentId = placeholder.dataset.content;
            let file_list_html = '';
            switch(contentId) {
                case 'file-list-1':
                    file_list_html = `<ul><h2 style="color: #f1841b;">Repo Root</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.black" style="color: #a6de03;">.black</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.editorconfig" style="color: #4bc38e;">.editorconfig</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.gitignore" style="color: #69a1e0;">.gitignore</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.hintrc" style="color: #c7b131;">.hintrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.jsbeautifyrc" style="color: #86b46e;">.jsbeautifyrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.jscsrc" style="color: #75d458;">.jscsrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.pre-commit-config.yaml" style="color: #c9a244;">.pre-commit-config.yaml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.pre-commit-hooks.yaml" style="color: #65d007;">.pre-commit-hooks.yaml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.prettierignore" style="color: #6e921e;">.prettierignore</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.prettierrc" style="color: #7cc17e;">.prettierrc</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.stylelintrc.json" style="color: #f7a388;">.stylelintrc.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vale.ini" style="color: #31eef7;">.vale.ini</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/CNAME" style="color: #df8a0d;">CNAME</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/LaunchZwift.ps1" style="color: #8ccd0e;">LaunchZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift-v2.md" style="color: #9b88ba;">MonitorZwift-v2.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift-v2.ps1" style="color: #4eca52;">MonitorZwift-v2.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift-v2.ps1%20-%20Shortcut.lnk" style="color: #eab914;">MonitorZwift-v2.ps1 - Shortcut.lnk</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MonitorZwift.ps1" style="color: #74daf2;">MonitorZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/MoveZwiftCleanPhotos.ps1" style="color: #c68a75;">MoveZwiftCleanPhotos.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/README.md" style="color: #51f10a;">README.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/SetPrimaryDefault.ps1" style="color: #80b680;">SetPrimaryDefault.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/SetPrimaryZwift.ps1" style="color: #d69e0f;">SetPrimaryZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/Zwift-Bike-Combos.xlsx" style="color: #98a9ac;">Zwift-Bike-Combos.xlsx</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/Zwift-Setup.lnk" style="color: #d0ad42;">Zwift-Setup.lnk</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/ZwiftSetup.lnk" style="color: #58b43e;">ZwiftSetup.lnk</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/file_list.md" style="color: #879f3a;">file_list.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/filelist.html" style="color: #aea542;">filelist.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/filelist.md" style="color: #fea16c;">filelist.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sitemap.xml" style="color: #bbb19d;">sitemap.xml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/test.ps1" style="color: #b98c9e;">test.ps1</a></li>
<h2 style="color: #f68c9a;">CSS</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/css/DSNotes.css" style="color: #7fa6b6;">sauce4zwift-mod-tippy/pages/css/DSNotes.css</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/css/ui.css" style="color: #e1b534;">sauce4zwift-mod-tippy/pages/css/ui.css</a></li>
<h2 style="color: #b38251;">JavaScript</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.eslintrc.js" style="color: #41ddbf;">.eslintrc.js</a></li>
<h2 style="color: #24a28b;">YAML</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/dependabot.yml" style="color: #a283cb;">.github/dependabot.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/labeler.yml" style="color: #71aba2;">.github/labeler.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/ActionLint.yml" style="color: #a8af7b;">.github/workflows/ActionLint.yml</a></li></ul>`;
                    break;
                case 'file-list-2':
                    file_list_html = `<ul><li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/codeql.yml" style="color: #e691b3;">.github/workflows/codeql.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/defender.yml" style="color: #43b989;">.github/workflows/defender.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/dependency-review.yml" style="color: #46d00e;">.github/workflows/dependency-review.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/generate-file-list.yml" style="color: #c1c183;">.github/workflows/generate-file-list.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/greetings.yml" style="color: #88e700;">.github/workflows/greetings.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/jekyll-gh-pages.yml" style="color: #de6f22;">.github/workflows/jekyll-gh-pages.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/label.yml" style="color: #7dcc88;">.github/workflows/label.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/ossar.yml" style="color: #ce74ff;">.github/workflows/ossar.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/osv-scanner.yml" style="color: #2cbb63;">.github/workflows/osv-scanner.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/scorecards.yml" style="color: #70c528;">.github/workflows/scorecards.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/sitemap.yml" style="color: #8fbd72;">.github/workflows/sitemap.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/stale.yml" style="color: #54e841;">.github/workflows/stale.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/static.yml" style="color: #ad77ca;">.github/workflows/static.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.github/workflows/super-linter.yml" style="color: #47abac;">.github/workflows/super-linter.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.markdownlint.yml" style="color: #fbba2b;">.markdownlint.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.scss-lint.yml" style="color: #5ad63a;">.scss-lint.yml</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/_config.yml" style="color: #f97d7b;">_config.yml</a></li>
<h2 style="color: #769111;">.vscode</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/generate_file_list.py" style="color: #98850e;">.vscode/generate_file_list.py</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/launch.json" style="color: #b4b83d;">.vscode/launch.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/settings.json" style="color: #2ca19d;">.vscode/settings.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/tasks.json" style="color: #4ff64c;">.vscode/tasks.json</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/.vscode/test_generate_file_list.py" style="color: #6beb00;">.vscode/test_generate_file_list.py</a></li>
<h2 style="color: #74955f;">sauce4zwift-mod-tippy</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/.gitignore" style="color: #9a9e62;">sauce4zwift-mod-tippy/.gitignore</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/Change%20Log.txt" style="color: #28aaa1;">sauce4zwift-mod-tippy/Change Log.txt</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/LICENSE" style="color: #3ee866;">sauce4zwift-mod-tippy/LICENSE</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/README.md" style="color: #dea139;">sauce4zwift-mod-tippy/README.md</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/manifest.json" style="color: #72c41c;">sauce4zwift-mod-tippy/manifest.json</a></li>
<h2 style="color: #8fba73;">sauce4zwift-mod-tippy/pages</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/DSNotes.html" style="color: #9da660;">sauce4zwift-mod-tippy/pages/DSNotes.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/chaseRace.html" style="color: #54ccca;">sauce4zwift-mod-tippy/pages/chaseRace.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/estimatedCalories.html" style="color: #4aad38;">sauce4zwift-mod-tippy/pages/estimatedCalories.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/estimatedFinish-v1.html" style="color: #bc9d18;">sauce4zwift-mod-tippy/pages/estimatedFinish-v1.html</a></li>
<h2 style="color: #b07a85;">sauce4zwift-mod-tippy/pages/images</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/checker_640.png" style="color: #dc8f03;">sauce4zwift-mod-tippy/pages/images/checker_640.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/greenConnect.png" style="color: #a0a924;">sauce4zwift-mod-tippy/pages/images/greenConnect.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/orangeConnect.png" style="color: #6a95fe;">sauce4zwift-mod-tippy/pages/images/orangeConnect.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/redConnect.png" style="color: #7bb70e;">sauce4zwift-mod-tippy/pages/images/redConnect.png</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/images/whiteConnect.png" style="color: #76a387;">sauce4zwift-mod-tippy/pages/images/whiteConnect.png</a></li></ul>`;
                    break;
                case 'file-list-3':
                    file_list_html = `<ul><h2 style="color: #37b418;">sauce4zwift-mod-tippy/pages/settings</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/settings/DSNotes.html" style="color: #e9a5f5;">sauce4zwift-mod-tippy/pages/settings/DSNotes.html</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/settings/estimatedFinish.html" style="color: #60dbcc;">sauce4zwift-mod-tippy/pages/settings/estimatedFinish.html</a></li>
<h2 style="color: #41afea;">sauce4zwift-mod-tippy/pages/src</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/DSNotes.mjs" style="color: #f690f4;">sauce4zwift-mod-tippy/pages/src/DSNotes.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/chaseRace.mjs" style="color: #708896;">sauce4zwift-mod-tippy/pages/src/chaseRace.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/estimatedFinish.mjs" style="color: #3593b2;">sauce4zwift-mod-tippy/pages/src/estimatedFinish.mjs</a></li>
<h2 style="color: #6ce349;">sauce4zwift-mod-tippy/pages/src/BM</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/common.mjs" style="color: #d66a8a;">sauce4zwift-mod-tippy/pages/src/BM/common.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/dataLookup.mjs" style="color: #62c1f4;">sauce4zwift-mod-tippy/pages/src/BM/dataLookup.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/notesLookup.mjs" style="color: #dd7cd9;">sauce4zwift-mod-tippy/pages/src/BM/notesLookup.mjs</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/pages/src/BM/settings.mjs" style="color: #7cab98;">sauce4zwift-mod-tippy/pages/src/BM/settings.mjs</a></li>
<h2 style="color: #d7b95e;">sauce4zwift-mod-tippy/src</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/sauce4zwift-mod-tippy/src/estimatedCalories.mjs" style="color: #5db917;">sauce4zwift-mod-tippy/src/estimatedCalories.mjs</a></li>
<h2 style="color: #66aff2;">src</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/src/generate_file_list.py" style="color: #2fe4ec;">src/generate_file_list.py</a></li>
<h2 style="color: #9eb30c;">tests</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/MonitorZwift-v2.Tests.ps1" style="color: #bd7f08;">tests/MonitorZwift-v2.Tests.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/test_OBSActivateAndRecord.ps1" style="color: #f15eed;">tests/test_OBSActivateAndRecord.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_LaunchZwift.ps1" style="color: #e05bff;">tests/tests_LaunchZwift.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_MoveZwiftCleanPhotos.ps1" style="color: #52ec42;">tests/tests_MoveZwiftCleanPhotos.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_PowerToysAwake.ps1" style="color: #57b2c3;">tests/tests_PowerToysAwake.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_SetPrimaryDefault.ps1" style="color: #7396dc;">tests/tests_SetPrimaryDefault.ps1</a></li>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/tests_SetPrimaryZwift.ps1" style="color: #e7a9b4;">tests/tests_SetPrimaryZwift.ps1</a></li>
<h2 style="color: #b3a5d8;">tests/old</h2>
<li><a href="https://github.com/Nick2bad4u/ZwiftScripts/blob/main/tests/old/tests_MonitorZwift-v2_3.ps1" style="color: #46b200;">tests/old/tests_MonitorZwift-v2_3.ps1</a></li></ul>`;
                    break;
            }
            placeholder.innerHTML = file_list_html;
        });
    }
});
</script>

<!-- FILE_LIST_END -->
