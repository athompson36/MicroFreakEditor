# Decisions

## SwiftUI + CoreMIDI (macOS/iPadOS first)
Chosen for fastest iteration and best native feel, plus AUv3 MIDI-effect path later.

## Standalone-first
We start as a standalone editor. Later:
- AUv3 MIDI Effect for iPad/mac DAW recall
- VST3 possible via separate JUCE build or bridge

## Optimistic state
We assume UI changes are the current state.
We apply incoming MIDI to update state when received.

## Two-mode sequencer
Device Mode (best effort) + App Mode (always works by emitting MIDI).

## Compact Mode
Global toggle:
- iPad: touch-first layout default
- macOS: compact layout default, can switch
