# MIDI Troubleshooting — MicroFreak Not Showing Up

## Quick Checks

### 1. **Check Console Output**
The app now logs all discovered MIDI devices to the console in debug builds. When you open the Settings screen, check Xcode's console for:
```
MIDI Sources (X):
  [0] Device Name 1
  [1] Device Name 2
MIDI Destinations (Y):
  [0] Device Name 1
  ...
```

Look for any device containing "MicroFreak", "Arturia", or similar.

### 2. **Refresh MIDI Devices**
- Click the **"Refresh"** button in the Settings screen
- Or use the "Refresh MIDI" button in the Perform view
- The app now automatically refreshes when MIDI devices are added/removed

### 3. **Check macOS MIDI Setup**
1. Open **Audio MIDI Setup** (Applications → Utilities → Audio MIDI Setup)
2. Check if "MicroFreak" appears in the MIDI Devices list
3. If it doesn't appear there, the issue is at the system level, not the app

## Common Issues & Solutions

### Issue: MicroFreak Connected via USB but Not Appearing

**Possible Causes:**
1. **USB Cable Issue**
   - Try a different USB cable (data-capable, not just power)
   - Try a different USB port

2. **Driver Missing**
   - Arturia MicroFreak may need drivers on macOS
   - Check [Arturia's website](https://www.arturia.com/support/downloads) for macOS drivers
   - Some devices work with generic USB MIDI drivers, others need specific drivers

3. **Device Not Powered On**
   - Ensure MicroFreak is powered on and in MIDI mode
   - Check MicroFreak's MIDI settings (some synths have MIDI enable/disable options)

4. **macOS Permissions**
   - System Settings → Privacy & Security → MIDI
   - Ensure MicroFreak Editor has permission to access MIDI devices
   - You may need to restart the app after granting permissions

### Issue: MicroFreak Shows Up in Other Apps but Not This One

**Possible Causes:**
1. **App Sandbox Restrictions**
   - The entitlements file includes App Sandbox
   - Check if removing App Sandbox temporarily helps (for testing only)
   - App Store builds require App Sandbox, but local testing can disable it

2. **MIDI Port Type**
   - Some devices create multiple MIDI ports (e.g., "MicroFreak MIDI In", "MicroFreak MIDI Out")
   - The app lists both Sources (inputs) and Destinations (outputs) separately
   - Check both lists in the Settings screen

3. **Virtual MIDI Ports**
   - Some DAWs create virtual MIDI ports
   - The MicroFreak might appear as a virtual port created by another app
   - Check Audio MIDI Setup for virtual ports

### Issue: Device Appears but Connection Fails

**Possible Causes:**
1. **Port Already in Use**
   - Another app might be using the MicroFreak's MIDI port
   - Close other MIDI apps (DAWs, MIDI monitors) and try again

2. **Wrong Port Selected**
   - Ensure you select the correct port:
     - **Source** = where MIDI comes FROM (MicroFreak → App)
     - **Destination** = where MIDI goes TO (App → MicroFreak)
   - For bidirectional communication, select the same device for both

## Debugging Steps

### Step 1: Verify System-Level Detection
```bash
# List all MIDI devices from command line
system_profiler SPUSBDataType | grep -i midi
system_profiler SPUSBDataType | grep -i arturia
```

### Step 2: Check MIDI Setup App
1. Open **Audio MIDI Setup**
2. Window → Show MIDI Studio
3. Look for MicroFreak in the device list
4. If present, right-click → "Test Setup" to verify it's working

### Step 3: Test with Another App
- Use a MIDI monitor app (e.g., MIDI Monitor, MIDI Monitor Pro)
- If MicroFreak appears there but not in MicroFreak Editor, it's an app-specific issue
- If it doesn't appear anywhere, it's a system/driver issue

### Step 4: Check App Console Logs
1. Run the app from Xcode
2. Open Settings screen
3. Check Xcode console for the debug output showing discovered devices
4. Look for any error messages

### Step 5: Verify MIDI Permissions
1. System Settings → Privacy & Security → MIDI
2. Ensure "MicroFreak Editor" is listed and enabled
3. If not listed, the app may need to request permission first

## MicroFreak-Specific Notes

### USB MIDI Class Compliance
- The MicroFreak should be USB MIDI Class compliant (works without drivers)
- If it's not appearing, it might need Arturia's MIDI Control Center or drivers

### MIDI Channel Settings
- The MicroFreak might be set to a specific MIDI channel
- Check MicroFreak's MIDI settings (usually in Global settings)
- The app currently doesn't filter by channel, so this shouldn't affect discovery

### Multiple MIDI Ports
- Some MicroFreak configurations create multiple ports:
  - "MicroFreak" (main port)
  - "MicroFreak MIDI" (if using MIDI DIN)
  - Check all available destinations in the app

## Testing the Fix

After making changes:
1. **Quit the app completely** (not just close the window)
2. **Unplug and replug** the MicroFreak USB cable
3. **Restart the app**
4. **Open Settings** and click "Refresh"
5. Check the console output for discovered devices

## Still Not Working?

If the MicroFreak still doesn't appear:

1. **Check Arturia Documentation**
   - [Arturia Support](https://www.arturia.com/support/contact)
   - MicroFreak user manual for MIDI setup instructions

2. **Try Alternative Connection**
   - If using USB, try MIDI DIN cables with a MIDI interface
   - If using MIDI DIN, try USB

3. **Report Issue**
   - Include console output from Xcode
   - Include output from `system_profiler SPUSBDataType`
   - Include screenshot of Audio MIDI Setup showing (or not showing) MicroFreak

---

**Last Updated:** After adding MIDI notification handling and debug logging
