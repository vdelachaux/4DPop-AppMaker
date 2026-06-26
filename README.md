<!-- MARKDOWN LINKS & IMAGES -->
[release-shield]: https://img.shields.io/github/v/release/vdelachaux/4DPop-AppMaker.svg?include_prereleases
[release-url]: https://github.com/vdelachaux/4DPop-AppMaker/releases/latest

[license-shield]: https://img.shields.io/github/license/vdelachaux/4DPop-AppMaker.svg

<!--BADGES-->
![Static Badge](https://img.shields.io/badge/Dev%20Component-blue?logo=4d&link=https%3A%2F%2Fdeveloper.4d.com)
![Static Badge](https://img.shields.io/badge/Project%20Dependencies-blue?logo=4d&link=https%3A%2F%2Fdeveloper.4d.com%2Fdocs%2FProject%2Fcomponents%2F%23loading-components)
<br>
[![release][release-shield]][release-url]
[![license][license-shield]](LICENSE)
<br>
<img src="https://img.shields.io/github/downloads/vdelachaux/4DPop-AppMaker/total" />

# 4DPop AppMaker

**4DPop AppMaker** is a 4D development component that automates the full pipeline for building, code-signing, and notarizing 4D applications and components — with a single click from within your project.

Once configured, AppMaker handles all the repetitive tasks that normally require manual intervention: assembling the build, signing the binaries, and submitting to Apple's notarization service.

---

## Highlights

- **One-click build** — trigger a full application or component build directly from 4D
- **Code signing** — automates `codesign` for macOS distribution
- **Notarization** — integrates with `notarytool` to submit and validate notarization with Apple
- **Build settings management** — reads and applies `buildApp.4DSettings` automatically
- **Environment detection** — adapts behavior for headless vs. interactive execution
- **Progress feedback** — built-in progress reporting during the build pipeline
- **Persistent preferences** — settings stored per project via XML preferences file

---

## Installation

### Via 4D Dependency Manager (recommended — 4D 21+)

1. Open your 4D project
2. Open the **Dependencies** panel (*Design menu > Dependencies*)
3. Click **+** then select **GitHub dependency**
4. Enter `vdelachaux/4DPop-AppMaker`
5. Choose the version and click **Add**
6. Restart 4D — the component loads automatically

> See [Adding a GitHub dependency](https://developer.4d.com/docs/Project/components/#adding-a-github-or-gitlab-dependency) for details.

### Binary install (legacy)

Download the latest `.4dbase` archive from the [Releases](https://github.com/vdelachaux/4DPop-AppMaker/releases/latest) page and place it in your project's `Components/` folder.

---

## Requirements

- 4D version **21** or later
- macOS (for code-signing and notarization features)
- A valid Apple Developer certificate in the keychain
- A `notarise.json` credentials file (placed in the project or user preferences folder)

---

## Usage

AppMaker exposes a `cs.AppMaker` class. The typical entry point is the companion palette accessible from the **4DPop** menu.

You can also invoke it programmatically:

```4d
var $maker := cs.AppMaker.new()
$maker.run()        // runs with UI
$maker.run(False)   // headless build
```

The build pipeline includes:
1. Flushing the cache
2. Loading build settings from `buildApp.4DSettings`
3. Building the application or component
4. Code-signing (macOS)
5. Notarizing with `notarytool` (macOS)

---

## Configuration

| File | Location | Purpose |
|------|----------|---------|
| `buildApp.4DSettings` | `Settings/` | Standard 4D build configuration |
| `4DPop AppMaker.xml` | Project preferences folder | AppMaker-specific preferences |
| `notarise.json` | Project or user preferences folder | Apple notarization credentials |

---

## Part of the 4DPop family

4DPop AppMaker is one component of the **[4DPop](https://github.com/vdelachaux/4DPop)** suite — a collection of developer tools integrated into a unified palette within the 4D Design environment.


