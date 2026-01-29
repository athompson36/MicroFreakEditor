# Cursor Context — MicroFreakEditor

## What we are building
A standalone MicroFreak software editor with a Pigments-inspired feel:
- Sectioned UI (Perform / Osc / Filter+Amp / Mod / Seq+Arp / Presets / Settings)
- 1:1 control mapping via MIDI CC + NRPN (and later SysEx)
- Compact Mode toggle: dense layout on macOS; touch-first layout on iPad

## Critical constraints
- MicroFreak parameter readback is not guaranteed for all parameters.
- We use optimistic local state; we listen for incoming MIDI to reflect hardware moves when available.
- Do not block the UI thread with MIDI work.

## Architecture rules (do not break)
UI -> AppState -> Domain Model -> MIDI Layer -> Device
Device -> MIDI Layer -> Domain Model -> AppState -> UI

- Domain must not import SwiftUI.
- MIDI layer must not import SwiftUI.
- UI binds to AppState only.
- Parameter mappings live in Domain/MicroFreak/ParameterRegistry.swift

## Naming conventions
- Parameters: `mf.<section>.<name>` e.g. `mf.filter.cutoff`
- Use normalized value (0.0–1.0) internally + display formatting in the registry.
- One source of truth for ranges & formatting: ParameterRegistry.

## Implementation order
1) ParameterRegistry + model storage
2) CoreMIDI manager (discover/connect/send/receive)
3) Minimal screens to prove the loop (Perform)
4) Add throttling/smoothing
5) Add NRPN mapping + send
6) Expand UI sections
7) Seq/Arp Grid (App Mode first)
8) Preset JSON store

## Compact Mode
- Global boolean: `AppState.isCompactMode`
- Each screen should have a compact + touch layout using the same components.
- Compact mode should prefer multi-column density on macOS.
