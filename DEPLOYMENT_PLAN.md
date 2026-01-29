# MicroFreakEditor — Comprehensive Deployment Plan

This document provides a deployment plan for the MicroFreakEditor multiplatform app (macOS 14+, iPadOS 17+). It assumes the Xcode project is created per `CREATE_XCODE_PROJECT.md` and covers setup, signing, distribution, and CI/CD.

---

## 1. Project Overview (from scan)

| Item | Current state |
|------|----------------|
| **Type** | SwiftUI multiplatform app (macOS + iPadOS) |
| **Min versions** | macOS 14+, iPadOS 17+ |
| **Dependencies** | SwiftUI, Foundation, CoreMIDI, Combine — no SPM/CocoaPods |
| **Xcode project** | Not in repo; created manually (scaffold) |
| **Source layout** | `MicroFreakEditorApp/` (App, Domain, MIDI, Services, UI) |
| **CI/CD** | None |
| **Versioning** | Not defined in repo |

---

## 2. Pre-Deployment Setup

### 2.1 Version & build numbers

- **Version (CFBundleShortVersionString)**: e.g. `1.0.0` — user-facing; bump for releases.
- **Build (CFBundleVersion)**: e.g. `1` or `2025012801` — must increase for each upload to App Store Connect.
- **Recommendation**: Set both in the Xcode project (each target) and/or in a shared `Info.plist`. Consider a single source (e.g. `xcconfig` or script) so macOS and iOS stay in sync.

### 2.2 Info.plist requirements

Ensure each target (macOS app, iPadOS app) has:

| Key | Purpose |
|-----|--------|
| `CFBundleDisplayName` | "MicroFreak Editor" (or desired name) |
| `CFBundleShortVersionString` | Version string |
| `CFBundleVersion` | Build number |
| `LSMinimumSystemVersion` (macOS) | `14.0` |
| `UIDeviceFamily` (iOS) | iPad only: `2` (or include iPhone if you add it later) |
| `UISupportedInterfaceOrientations` (iPad) | As needed (e.g. all for editor) |
| `ITSAppUsesNonExemptEncryption` | Set to `NO` if you use no custom crypto (simplifies export compliance) |
| `NSMicrophoneUsageDescription` | Only if you add mic access later |
| **MIDI** | iPadOS: no default privacy key for local MIDI; Network MIDI may need entitlements (see 2.3). |

Add any App Store–required keys (e.g. export compliance, content rights) as you prepare the first submission.

### 2.3 Entitlements

- **macOS**: Usually no special entitlement for CoreMIDI (local/USB/Bluetooth). If you use App Sandbox, ensure **Audio Input** (and **Outgoing Network** only if you add network MIDI) are enabled as needed.
- **iPadOS**: CoreMIDI works for USB/Bluetooth without extra entitlements. If you add **Network MIDI** (Apple’s network MIDI), you may need the **Network MIDI** capability or associated entitlements; add the capability in Xcode and let it manage the entitlement file.
- **Recommended**: Create one entitlements file per target (e.g. `MicroFreakEditor-macOS.entitlements`, `MicroFreakEditor-iOS.entitlements`) and enable only what you use (e.g. App Sandbox on macOS with appropriate sub-items).

### 2.4 App Sandbox (macOS)

If you enable App Sandbox for macOS:

- Enable **Outgoing Network (Client)** only if you add network MIDI or other network features.
- **Audio Input** if you ever add audio input.
- **No special “MIDI” checkbox**; CoreMIDI works within sandbox for local MIDI.

### 2.5 .gitignore

Add a `.gitignore` so build artifacts and secrets are not committed, for example:

```gitignore
# Xcode
build/
DerivedData/
*.xcuserstate
*.xcworkspace/xcuserdata/
*.xcodeproj/xcuserdata/
*.xcodeproj/project.xcworkspace/xcuserdata/

# macOS
.DS_Store

# Secrets / provisioning (if stored locally)
*.mobileprovision
*.p12
ExportOptions.plist
fastlane/report.xml
fastlane/Preview.html
```

Optionally add `*.xcodeproj` and `*.xcworkspace` if you decide to generate the project (e.g. via XcodeGen) and not commit them; for now the docs say to create the project in the repo root, so committing the `.xcodeproj` is reasonable.

---

## 3. Code Signing & Provisioning

### 3.1 Apple Developer Program

- Enroll in [Apple Developer Program](https://developer.apple.com/programs/) (required for TestFlight and App Store).
- Create an **App ID** per platform (e.g. `com.yourcompany.MicroFreakEditor` for macOS and iOS, or separate IDs if you prefer).

### 3.2 Certificates & profiles

- **Development**: Apple Development certificate + development provisioning profiles for macOS and iOS (iPad), so you can run on device/simulator.
- **Distribution**: 
  - **App Store**: Apple Distribution certificate + App Store provisioning profiles for both targets.
  - **Ad Hoc** (optional): Distribution certificate + Ad Hoc provisioning profiles (iOS only; macOS can use Developer ID for outside-App-Store).
- **macOS outside App Store**: Use **Developer ID Application** certificate and sign with that for notarization and distribution (e.g. download from your site).

### 3.3 Xcode configuration

- In **Signing & Capabilities** for each target, select your Team and let Xcode manage signing, or use manual provisioning with the profiles above.
- Use the same Bundle ID as in App Store Connect for the app you create there.

---

## 4. Build & Archive

### 4.1 Schemes

- One scheme per target (e.g. “MicroFreakEditor (macOS)” and “MicroFreakEditor (iOS)”) with **Run** and **Archive** configured.
- **Archive** should use **Release** and the correct destination (e.g. “Any Mac”, “Generic iOS Device” or “Any iOS Device (arm64)”).

### 4.2 Command-line build (for CI)

Example (adjust scheme and destination):

```bash
# macOS
xcodebuild -scheme "MicroFreakEditor (macOS)" -destination "platform=macOS" -configuration Release clean build

# iOS (iPad)
xcodebuild -scheme "MicroFreakEditor (iOS)" -destination "generic/platform=iOS" -configuration Release clean build
```

Archive (example for macOS):

```bash
xcodebuild -scheme "MicroFreakEditor (macOS)" -destination "generic/platform=macOS" -configuration Release archive -archivePath build/MicroFreakEditor-macOS.xcarchive
```

Export the archive with the appropriate export options (App Store, Ad Hoc, Developer ID) as in section 5.

### 4.3 Version in build

To inject version/build from CI or script, use `agvtool` or set `INFOPLIST_KEY_CFBundleShortVersionString` and `INFOPLIST_KEY_CFBundleVersion` in the `xcodebuild` command or via an `xcconfig` that the project uses.

---

## 5. Distribution

### 5.1 App Store Connect

- Create one app in App Store Connect with **macOS** and **iOS** (or two apps if you prefer separate listings).
- Fill in metadata: description, keywords, screenshots, privacy policy URL, support URL, category (e.g. Music).
- **Export compliance**: If `ITSAppUsesNonExemptEncryption` is `NO`, you can often answer “No” to encryption in App Store Connect.
- **Content rights**: Confirm you have rights to the name and assets (e.g. “MicroFreak” in relation to Arturia).

### 5.2 TestFlight

- Upload builds via Xcode (Organizer → Distribute App → App Store Connect) or via `xcodebuild -exportArchive` and then Transporter / `xcrun altool` / `xcrun notarytool` as applicable.
- Add internal testers (Apple ID) and optionally external testers (requires Beta App Review for first build).
- Use TestFlight for QA and pre-release validation on real devices.

### 5.3 App Store release

- Submit the build from App Store Connect for **App Review**.
- Choose manual release or automatic release after approval.
- For a multiplatform app, you can ship macOS and iPadOS together or in sequence (same or different version numbers per platform if needed).

### 5.4 Ad Hoc (iOS) / Developer ID (macOS)

- **iOS**: Export archive with “Ad Hoc” and distribute the `.ipa` to registered device UDIDs (max 100 devices per year per Apple ID).
- **macOS**: Sign with **Developer ID**, notarize with `xcrun notarytool`, staple the ticket, then distribute the `.app` or `.dmg`/`.pkg` outside the App Store.

---

## 6. CI/CD Options

### 6.1 Xcode Cloud

- Enable in App Store Connect and connect the repo (GitHub/GitLab/Bitbucket).
- Configure workflow: build on commit/PR, run tests, archive, and optionally upload to TestFlight.
- Good fit if the team is small and you want minimal YAML; runs in Apple’s environment.

### 6.2 GitHub Actions (or other CI)

- **Runner**: Use **macOS** runner (e.g. `macos-14`) so `xcodebuild` and signing work.
- **Steps**: Checkout → select Xcode version → install/import certificates and provisioning profiles (e.g. from secrets) → `xcodebuild archive` → export IPA/APP → upload to TestFlight via `xcrun altool` or Transporter.
- **Secrets**: Store signing certificate (e.g. base64 `.p12`), provisioning profiles, Apple ID, app-specific password, and optionally API key for App Store Connect.
- **Recommendation**: Add a workflow file (e.g. `.github/workflows/ci.yml`) for build + test, and a separate workflow (e.g. `release.yml`) for archive + TestFlight/App Store upload on tag or manual dispatch.

### 6.3 Fastlane

- **match**: Manage certificates and profiles in a private repo.
- **gym**: Build and archive.
- **pilot**: Upload to TestFlight.
- **deliver**: Submit for review and manage metadata.
- Reduces repetitive steps and standardizes deployment across machines; can be driven by GitHub Actions or Xcode Cloud.

---

## 7. Release Checklist

Before each release (e.g. 1.0.0):

- [ ] Version and build number updated (macOS + iPadOS targets).
- [ ] Release notes / “What’s New” prepared for TestFlight and App Store.
- [ ] All required Info.plist keys and entitlements verified.
- [ ] Tested on minimum OS versions (macOS 14, iPadOS 17) and representative devices (Intel/Apple Silicon Mac; target iPad models).
- [ ] MIDI flow tested: connect, send CC, receive (if applicable), and disconnect.
- [ ] No debug-only code or test backdoors in Release.
- [ ] Export compliance and privacy answers confirmed in App Store Connect.
- [ ] Certificates and profiles valid; signing succeeds for both targets.
- [ ] Archive exported with correct method (App Store / Ad Hoc / Developer ID).
- [ ] TestFlight build uploaded and tested (optional but recommended).
- [ ] Submit for App Review (or distribute Ad Hoc/Developer ID build).

---

## 8. Post-Release

- **Monitoring**: Use App Store Connect for crashes, ratings, and feedback.
- **Updates**: Follow the same process; always bump `CFBundleVersion` (and usually `CFBundleShortVersionString`) for each upload.
- **Rollback**: If a build is rejected or has a critical bug, fix and upload a new build; you cannot “revert” a live App Store version, only replace with a new submission.

---

## 9. Suggested Implementation Order

1. **Immediate**  
   - Create/confirm Xcode project and schemes (per `CREATE_XCODE_PROJECT.md`).  
   - Add version/build to project or Info.plist.  
   - Add `.gitignore`.  
   - Configure signing and entitlements for Dev + App Store (and Ad Hoc/Developer ID if needed).

2. **Short term**  
   - Define one place for version numbers (e.g. `xcconfig` or script).  
   - Document exact steps to produce an archive and upload to TestFlight in your environment.  
   - First TestFlight build and internal test.

3. **Medium term**  
   - Add CI: at least build + run tests on PR/push (e.g. GitHub Actions on macOS).  
   - Optional: Automate TestFlight upload on tag or manual trigger.  
   - Optional: Introduce Fastlane or Xcode Cloud for repeatable deployment.

4. **Ongoing**  
   - Use the release checklist for every release.  
   - Keep entitlements and Info.plist in sync with actual features (e.g. Network MIDI when added).

---

## 10. Summary

| Area | Action |
|------|--------|
| **Project** | Xcode project in repo (or generated); two targets (macOS, iPadOS). |
| **Versioning** | CFBundleShortVersionString + CFBundleVersion in both targets; single source preferred. |
| **Info.plist** | Display name, min OS, export compliance, device family/orientation. |
| **Entitlements** | Per target; Sandbox + capabilities as needed; Network MIDI only if used. |
| **Signing** | Development + App Store (and Ad Hoc/Developer ID if distributing outside store). |
| **Build** | Schemes for Run + Archive; command-line `xcodebuild` for CI. |
| **Distribution** | App Store Connect → TestFlight → App Store; optional Ad Hoc / Developer ID. |
| **CI/CD** | Start with build + test; add archive + TestFlight when ready; consider Fastlane or Xcode Cloud. |
| **Process** | Use the release checklist and keep this plan updated as the app evolves. |

This plan aligns with the current codebase (SwiftUI, CoreMIDI, no external dependencies) and the goals in `README.md`, `CONTEXT.md`, and `ROADMAP.md`. Adjust Bundle IDs, team names, and distribution choices to match your organization.
