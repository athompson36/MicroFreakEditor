# MicroFreakEditor — Features

## Implemented (v1)

### Sections & UI

| Section | Description |
|--------|--------------|
| **Perform** | Quick controls: Glide, Filter Cutoff/Resonance, Amp Level, Keyboard Spice. Compact vs touch layout. |
| **Osc** | Oscillator: Type, Wave, Timbre, Shape. All mapped to MicroFreak CC. |
| **Filter+Amp** | Filter (Cutoff, Resonance), Amp (Level), Cycling Envelope (Rise, Fall, Hold, Amount), Envelope (Attack, Decay, Sustain, Filter Amount). |
| **Mod** | Mod Matrix placeholder; drag/drop and mod rings planned for a future update. |
| **Seq/Arp** | Arp/Seq rate (free + sync), LFO rate (free + sync). Step grid placeholder for App Mode sequencer. |
| **Presets** | Save current state as preset (name), list presets, load preset, delete preset. Stored as JSON in Application Support. |
| **Settings** | MIDI source/destination pickers, connection status, Compact mode toggle, Refresh. |

### Parameter Registry

All MicroFreak CC parameters from [midi.guide](https://midi.guide/d/arturia/microfreak/) are in `ParameterRegistry`:

- **General:** Glide (CC 5)
- **Oscillator:** Type (9), Wave (10), Timbre (12), Shape (13)
- **Filter:** Cutoff (23), Resonance (83)
- **Amp:** Level (7)
- **Cycling envelope:** Rise (102), Fall (103), Hold (28), Amount (24)
- **Arp/Seq:** Rate free (91), Rate sync (92)
- **LFO:** Rate free (93), Rate sync (94)
- **Envelope:** Attack (105), Decay (106), Sustain (29), Filter amount (26)
- **Keyboard:** Hold (64), Spice (2)

### Layout

- **Compact mode:** Dense horizontal layout (macOS-friendly).
- **Touch mode:** Adaptive grid for iPad.
- Toggle in each section’s top bar and in Settings.

### MIDI

- CoreMIDI discovery, source/destination selection, connection status in UI.
- CC send on parameter change; NRPN support in mapping layer (used when params use NRPN).
- MIDI setup change notifications refresh the device list.

### Presets

- Save: current parameter state → JSON file in `~/Library/Application Support/MicroFreakEditor/`.
- Load: replace in-memory model (optionally send full dump to synth in a future update).
- List and delete presets.

## Planned (roadmap)

- **Mod Matrix:** Mod routes UI, mod rings, drag/drop.
- **Seq/Arp step grid:** Step sequencer, internal clock, MIDI clock in/out, pattern save/recall.
- **Presets v2:** Send full parameter dump to synth on load; compare/diff, A/B.
- **SysEx (best-effort):** Device handshake, partial dump/restore.
- **Throttling/smoothing:** Parameter throttling and smoothing for MIDI send.
- **Hardware knob learn:** Optional MIDI learn for parameters.
