import Foundation

enum CCMapper {
    static func makeCC(channel: UInt8, number: UInt8, value: UInt8) -> [UInt8] {
        [0xB0 | (channel & 0x0F), number, value]
    }
}
