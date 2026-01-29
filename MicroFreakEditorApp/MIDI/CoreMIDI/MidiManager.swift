import Foundation
import CoreMIDI

final class MidiManager: ObservableObject {
    @Published private(set) var sources: [MIDIEndpointRef] = []
    @Published private(set) var destinations: [MIDIEndpointRef] = []

    private var client = MIDIClientRef()
    private var inputPort = MIDIPortRef()
    private var outputPort = MIDIPortRef()

    private var connectedSource: MIDIEndpointRef?
    private var connectedDestination: MIDIEndpointRef?

    var onReceiveMessage: (([UInt8]) -> Void)?

    init() {
        setup()
        refreshEndpoints()
    }

    deinit {
        if inputPort != 0 { MIDIPortDispose(inputPort) }
        if outputPort != 0 { MIDIPortDispose(outputPort) }
        if client != 0 { MIDIClientDispose(client) }
    }

    private func setup() {
        MIDIClientCreateWithBlock("MicroFreakEditor" as CFString, &client) { [weak self] notification in
            guard let self else { return }
            // Refresh endpoints when MIDI setup changes (devices added/removed)
            let messageID = notification.pointee.messageID
            if messageID == .msgSetupChanged {
                DispatchQueue.main.async {
                    self.refreshEndpoints()
                }
            }
        }

        MIDIInputPortCreateWithBlock(client, "Input" as CFString, &inputPort) { [weak self] packetList, _ in
            guard let self else { return }
            let packets = packetList.pointee
            var packet = packets.packet
            for _ in 0..<packets.numPackets {
                let bytes = Mirror(reflecting: packet.data).children
                    .prefix(Int(packet.length))
                    .compactMap { $0.value as? UInt8 }
                self.onReceiveMessage?(bytes)
                packet = MIDIPacketNext(&packet).pointee
            }
        }

        MIDIOutputPortCreate(client, "Output" as CFString, &outputPort)
    }

    func refreshEndpoints() {
        let sourceCount = MIDIGetNumberOfSources()
        let destCount = MIDIGetNumberOfDestinations()
        
        sources = (0..<sourceCount).map { MIDIGetSource($0) }
        destinations = (0..<destCount).map { MIDIGetDestination($0) }
        
        // Debug: Print discovered devices
        #if DEBUG
        print("MIDI Sources (\(sourceCount)):")
        for (index, source) in sources.enumerated() {
            var name: Unmanaged<CFString>?
            MIDIObjectGetStringProperty(source, kMIDIPropertyName, &name)
            let nameStr = (name?.takeRetainedValue() as String?) ?? "Unknown"
            print("  [\(index)] \(nameStr)")
        }
        
        print("MIDI Destinations (\(destCount)):")
        for (index, dest) in destinations.enumerated() {
            var name: Unmanaged<CFString>?
            MIDIObjectGetStringProperty(dest, kMIDIPropertyName, &name)
            let nameStr = (name?.takeRetainedValue() as String?) ?? "Unknown"
            print("  [\(index)] \(nameStr)")
        }
        #endif
    }

    func connect(source: MIDIEndpointRef?, destination: MIDIEndpointRef?) {
        if let src = connectedSource {
            MIDIPortDisconnectSource(inputPort, src)
        }
        connectedSource = source
        connectedDestination = destination

        if let src = source {
            MIDIPortConnectSource(inputPort, src, nil)
        }
    }

    func send(_ bytes: [UInt8], to destination: MIDIEndpointRef? = nil) {
        let dest = destination ?? connectedDestination
        guard let dest, dest != 0 else { return }

        let bufferSize = 256
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        let length = bytes.count

        buffer.withUnsafeMutableBytes { rawBuffer in
            let listPtr = rawBuffer.baseAddress!.assumingMemoryBound(to: MIDIPacketList.self)
            var packetPtr = MIDIPacketListInit(listPtr)
            bytes.withUnsafeBufferPointer { ptr in
                packetPtr = MIDIPacketListAdd(listPtr, bufferSize, packetPtr, 0, length, ptr.baseAddress!)
            }
            if packetPtr != nil {
                MIDISend(outputPort, dest, listPtr)
                #if DEBUG
                if bytes.count >= 3, (bytes[0] & 0xF0) == 0xB0 {
                    print("MIDI CC sent: ch \(bytes[0] & 0x0F) cc \(bytes[1]) val \(bytes[2])")
                }
                #endif
            }
        }
    }

    /// Returns display name for an endpoint (for connection status UI).
    func name(for endpoint: MIDIEndpointRef?) -> String {
        guard let endpoint, endpoint != 0 else { return "" }
        var name: Unmanaged<CFString>?
        MIDIObjectGetStringProperty(endpoint, kMIDIPropertyName, &name)
        return (name?.takeRetainedValue() as String?) ?? "Unknown"
    }
}
