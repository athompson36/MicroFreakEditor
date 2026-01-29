# Next Steps — MicroFreakEditor Deployment

The app builds and runs on macOS. Here's what to do next to prepare for deployment.

## ✅ Completed

- [x] Xcode project created (via XcodeGen)
- [x] Version and build numbers configured (1.0.0 / 1)
- [x] Entitlements files created for macOS and iOS
- [x] macOS build verified and app runs

## 🔄 Immediate Next Steps

### 1. Set Up iOS Code Signing

**In Xcode:**
1. Open `MicroFreakEditor.xcodeproj`
2. Select the **MicroFreakEditor_iOS** target
3. Go to **Signing & Capabilities** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (requires Apple Developer account)
6. Xcode will create/select provisioning profiles automatically

**Result:** iOS builds will work for simulator and device.

### 2. Test iOS Build

```bash
# Build for iOS Simulator
xcodebuild -scheme MicroFreakEditor_iOS -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' -configuration Debug build

# Or open in Xcode and run on iPad simulator
```

### 3. Verify App Functionality

**Test on macOS:**
- [ ] App launches without crashes
- [ ] Navigation between sections works (Perform, Settings, etc.)
- [ ] MIDI Settings screen shows available MIDI ports
- [ ] Can select MIDI source/destination
- [ ] Parameter knobs in Perform view respond to input
- [ ] MIDI messages are sent when adjusting parameters

**Test on iPad (after signing setup):**
- [ ] App launches on iPad simulator/device
- [ ] Touch interactions work correctly
- [ ] MIDI port selection works
- [ ] UI adapts to iPad screen size

## 📋 Pre-Deployment Checklist

### Code & Configuration

- [ ] Verify all placeholder CC numbers in `ParameterRegistry.swift` are replaced with actual MicroFreak mappings
- [ ] Test MIDI communication with actual MicroFreak hardware (if available)
- [ ] Verify no debug/console logs left in production code
- [ ] Review and update `INFOPLIST_KEY_ITSAppUsesNonExemptEncryption` if you add encryption

### App Store Connect Setup

See **[APP_STORE_CONNECT.md](./APP_STORE_CONNECT.md)** for the full checklist.

1. **Create App Record:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Create new app: "MicroFreak Editor"
   - Bundle ID: `com.microfreakeditor.MicroFreakEditor`
   - Platforms: macOS and iOS (or separate apps if preferred)

2. **Prepare Metadata:**
   - App description
   - Keywords
   - Screenshots (required):
     - macOS: 1280x800, 1440x900, 2560x1600, 2880x1800
     - iPad: 12.9" and 11" sizes
   - App icon (1024x1024)
   - Privacy policy URL (required)
   - Support URL

3. **Export Compliance:**
   - Answer "No" to encryption (since `ITSAppUsesNonExemptEncryption` is `NO`)

### Build & Archive

**macOS:**
```bash
# Archive
xcodebuild -scheme MicroFreakEditor_macOS -destination 'generic/platform=macOS' -configuration Release archive -archivePath build/MicroFreakEditor-macOS.xcarchive

# Export for App Store
xcodebuild -exportArchive -archivePath build/MicroFreakEditor-macOS.xcarchive -exportPath build/macOS -exportOptionsPlist ExportOptions.plist
```

**iOS:**
```bash
# Archive
xcodebuild -scheme MicroFreakEditor_iOS -destination 'generic/platform=iOS' -configuration Release archive -archivePath build/MicroFreakEditor-iOS.xcarchive

# Export for App Store
xcodebuild -exportArchive -archivePath build/MicroFreakEditor-iOS.xcarchive -exportPath build/iOS -exportOptionsPlist ExportOptions.plist
```

### TestFlight

1. Upload builds via Xcode Organizer or Transporter
2. Add internal testers (Apple ID)
3. Submit for Beta App Review (first external test build)
4. Test on real devices before App Store submission

## ✅ CI/CD Setup (Done)

### GitHub Actions

`.github/workflows/ci.yml` runs on every push/PR to `main`:
- Installs XcodeGen and generates the Xcode project
- Builds **MicroFreakEditor_macOS** (Debug)
- Builds **MicroFreakEditor_iOS** for iPad Simulator (Debug)

If iOS build fails in CI (e.g. signing), it may be due to no development team on the runner; macOS build still validates the project.

### Xcode Cloud

1. Connect repo in App Store Connect → Xcode Cloud
2. Create workflow: build on commit, run tests, archive
3. Optionally auto-upload to TestFlight

## 📝 Version Management

**Current:** Version 1.0.0, Build 1

**To update:**
1. Edit `project.yml`:
   - `MARKETING_VERSION`: User-facing version (e.g., "1.1.0")
   - `CURRENT_PROJECT_VERSION`: Build number (increment for each upload)
2. Run `xcodegen generate`
3. Build and archive

**Build number rules:**
- Must increase for each App Store Connect upload
- Use format: `1`, `2`, `3`... or date-based: `2025012801`

## 🔧 Troubleshooting

**iOS build fails: "requires a development team"**
→ Set Team in Xcode: Target → Signing & Capabilities → Team

**macOS build fails: "App Sandbox"**
→ Entitlements file is configured. If issues persist, check `MicroFreakEditor-macOS.entitlements`

**MIDI ports not showing**
→ Check System Settings → Privacy & Security → MIDI (macOS) or Settings → Privacy → Local Network (iOS)

## 📚 Resources

- [DEPLOYMENT_PLAN.md](./DEPLOYMENT_PLAN.md) - Full deployment guide
- [CREATE_XCODE_PROJECT.md](./CREATE_XCODE_PROJECT.md) - Project setup
- [ROADMAP.md](./ROADMAP.md) - Feature roadmap
- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer Documentation](https://developer.apple.com/documentation)

---

**Last updated:** After initial macOS build success
