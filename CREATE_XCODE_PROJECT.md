# Xcode Project — MicroFreakEditor

The Xcode project is **generated from `project.yml`** using [XcodeGen](https://github.com/yonaskolb/XcodeGen). You can open the existing `.xcodeproj` or regenerate it when you change the spec.

## Open the project

1. Open **MicroFreakEditor.xcodeproj** in Xcode (double-click or `open MicroFreakEditor.xcodeproj`).
2. Select the **MicroFreakEditor_macOS** or **MicroFreakEditor_iOS** scheme.
3. Choose a run destination (e.g. “My Mac” or an iPad simulator).
4. Build & Run (⌘R).

**iOS:** The first time you build for a device or simulator, set your **Team** in **Signing & Capabilities** for the `MicroFreakEditor_iOS` target.

## Regenerate the project (after editing `project.yml`)

If you change `project.yml` (e.g. add files, targets, or settings), regenerate the Xcode project:

```bash
# Install XcodeGen once (if needed)
brew install xcodegen

# From the repo root
xcodegen generate
```

Then open **MicroFreakEditor.xcodeproj** again. Any manual changes made only in Xcode (e.g. to the project file) will be overwritten by `xcodegen generate`.

## What the generated project has

- **Targets:** `MicroFreakEditor_iOS` (iPadOS 17+) and `MicroFreakEditor_macOS` (macOS 14+).
- **Source:** All Swift files under `MicroFreakEditorApp/` are included in both targets.
- **Schemes:** `MicroFreakEditor_iOS` and `MicroFreakEditor_macOS` (one per target).
- **Settings:** Bundle ID, display name, generated Info.plist, device family (iPad only), export compliance.

## Quick run (macOS)

- In Xcode: scheme **MicroFreakEditor_macOS** → Run.
- From terminal:  
  `xcodebuild -scheme MicroFreakEditor_macOS -destination 'platform=macOS' -configuration Debug build`

## MIDI

After running, open the **Settings** tab in the app to choose MIDI input and output ports.
