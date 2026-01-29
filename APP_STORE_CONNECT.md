# App Store Connect — MicroFreakEditor

Checklist to create the app in App Store Connect and prepare for TestFlight/App Store.

## 1. Create the app in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com) and sign in.
2. **My Apps** → **+** → **New App**.
3. Fill in:
   - **Platforms:** macOS and iOS (or create two apps if you prefer separate listings).
   - **Name:** MicroFreak Editor
   - **Primary Language:** English (or your choice).
   - **Bundle ID:** Select `com.microfreakeditor.MicroFreakEditor` (create it under Certificates, Identifiers & Profiles if needed).
   - **SKU:** e.g. `microfreak-editor-1`.
   - **User Access:** Full Access (or as needed).

## 2. App information

- **Subtitle** (optional): e.g. "Editor for Arturia MicroFreak"
- **Category:** Music
- **Secondary Category** (optional): Utilities or Productivity
- **Privacy Policy URL:** Required — host a page that describes what data the app collects (e.g. “This app does not collect personal data. MIDI is used only to communicate with connected devices.”).

## 3. Metadata and screenshots

### Description (required)

Example:

```
MicroFreak Editor is a standalone editor for the Arturia MicroFreak synthesizer. Control filter, resonance, and level from your Mac or iPad over MIDI.

• Real-time parameter control via MIDI CC
• Pigments-inspired interface
• macOS and iPad support
• Select your MicroFreak as MIDI destination in Settings to get started
```

### Keywords (optional, comma-separated)

e.g. `MicroFreak,Arturia,MIDI,synthesizer,editor,music`.

### Screenshots (required)

- **macOS:** 1280×800, 1440×900, 2560×1600, 2880×1800 (or use the sizes App Store Connect asks for).
- **iPad:** 12.9" and 11" sizes as required.

Capture the app with the Perform view and Settings (MIDI ports / connection status) visible.

### App icon

- 1024×1024 px, no transparency, no rounded corners (Apple will apply the mask).

## 4. Version and build

- **Version:** 1.0.0 (must match `MARKETING_VERSION` in project).
- **Build:** Upload the first build from Xcode; build number must match `CURRENT_PROJECT_VERSION` (e.g. 1).

## 5. Export compliance

- **Uses encryption?** Answer **No** (we set `ITSAppUsesNonExemptEncryption = NO`).
- If asked, confirm the app does not use custom encryption.

## 6. Archive and export (local)

### ExportOptions.plist

1. Copy the example:  
   `cp ExportOptions.plist.example ExportOptions.plist`
2. Edit `ExportOptions.plist`:
   - Replace `YOUR_TEAM_ID` with your Apple Developer Team ID.
   - Replace `YOUR_APP_STORE_PROVISIONING_PROFILE_NAME` with the name of your App Store provisioning profile for `com.microfreakeditor.MicroFreakEditor` (or leave automatic signing to manage it).
3. Do **not** commit `ExportOptions.plist` (it’s in `.gitignore`).

### Archive from Xcode

1. **macOS:** Scheme **MicroFreakEditor_macOS** → Product → Archive.  
2. **iOS:** Scheme **MicroFreakEditor_iOS** → Product → Archive.  
3. In the Organizer, select the archive → **Distribute App** → **App Store Connect** → **Upload** and follow the steps.

### Or from command line

```bash
# macOS archive
xcodebuild -scheme MicroFreakEditor_macOS -destination 'generic/platform=macOS' -configuration Release archive -archivePath build/MicroFreakEditor-macOS.xcarchive

# Export (after editing ExportOptions.plist)
xcodebuild -exportArchive -archivePath build/MicroFreakEditor-macOS.xcarchive -exportPath build/macOS -exportOptionsPlist ExportOptions.plist

# iOS archive
xcodebuild -scheme MicroFreakEditor_iOS -destination 'generic/platform=iOS' -configuration Release archive -archivePath build/MicroFreakEditor-iOS.xcarchive

# Export
xcodebuild -exportArchive -archivePath build/MicroFreakEditor-iOS.xcarchive -exportPath build/iOS -exportOptionsPlist ExportOptions.plist
```

Then upload the exported `.ipa` / `.app` via Transporter or Xcode Organizer.

## 7. TestFlight

1. After the first upload, the build appears under **TestFlight** for the app.
2. Add **Internal Testers** (Apple ID).
3. For **External Testers**, submit the build for **Beta App Review** (required for the first external build).
4. Install via TestFlight on your devices to verify before submitting for App Review.

## 8. Submit for App Review

When ready:

1. In App Store Connect, complete all required fields (screenshots, description, etc.).
2. Select the build you uploaded.
3. Submit for review.
4. Choose manual or automatic release after approval.

---

**Next:** See [NEXT_STEPS.md](./NEXT_STEPS.md) and [DEPLOYMENT_PLAN.md](./DEPLOYMENT_PLAN.md) for more detail.
