import Foundation
import CoreMIDI

struct DeviceSession: Equatable {
    var selectedSource: MIDIEndpointRef? = nil
    var selectedDestination: MIDIEndpointRef? = nil

    var isConnected: Bool {
        (selectedSource ?? 0) != 0 || (selectedDestination ?? 0) != 0
    }
}
