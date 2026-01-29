# MicroFreakEditor (Standalone) — macOS + iPadOS

A standalone, 1:1+ editor for the Arturia MicroFreak with a Pigments-inspired UI.
Built with SwiftUI + CoreMIDI. macOS/iPadOS first.

## Goals (v1)
- Real-time editing via MIDI (CC + NRPN where applicable)
- Pigments-like UX: sections, inspector, mod visualization (later)
- Seq/Arp Grid with two modes:
  - Device Mode (best-effort writes to MicroFreak)
  - App Mode (sequencer runs in-app; outputs MIDI to MicroFreak)
- Presets: local JSON snapshots (v1), SysEx-based dumps later

## Platforms
- macOS 14+
- iPadOS 17+

## Quick Start (Xcode)
1. In Xcode: **File → New → Project…**
2. Choose **Multiplatform App** (SwiftUI)
3. Product Name: `MicroFreakEditor`
4. Bundle ID: your choice
5. Minimums: macOS 14, iPadOS 17
6. Create the project in this repo root (same folder as this README)
7. In the project navigator, drag the `MicroFreakEditorApp/` folder into the app target (check “Copy items if needed”)
8. Ensure these files are in the main app target:
   - `MicroFreakEditorApp/App/*`
   - `MicroFreakEditorApp/Domain/*`
   - `MicroFreakEditorApp/MIDI/*`
   - `MicroFreakEditorApp/Services/*`
   - `MicroFreakEditorApp/UI/*`
9. Build & Run.

## MIDI Notes
- This app uses optimistic state: when you turn a knob in the UI, we update the model immediately and transmit MIDI.
- The initial CC numbers in `ParameterRegistry.swift` are placeholders so the project compiles. Replace with verified MicroFreak mappings.

## Folder Map
- `MicroFreakEditorApp/App/` app entry + global state
- `MicroFreakEditorApp/Domain/` synth model, parameters, presets, sequencer data
- `MicroFreakEditorApp/MIDI/` CoreMIDI, mapping, throttling/smoothing, logging
- `MicroFreakEditorApp/UI/` views, theme, custom controls
