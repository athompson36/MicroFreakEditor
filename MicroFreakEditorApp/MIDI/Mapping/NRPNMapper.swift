import Foundation

enum NRPNMapper {
    static func makeNRPN(channel: UInt8, parameter: UInt16, value14: UInt16) -> [[UInt8]] {
        let ch = channel & 0x0F
        let paramMSB = UInt8((parameter >> 7) & 0x7F)
        let paramLSB = UInt8(parameter & 0x7F)

        let value = min(value14, 16383)
        let valueMSB = UInt8((value >> 7) & 0x7F)
        let valueLSB = UInt8(value & 0x7F)

        return [
            CCMapper.makeCC(channel: ch, number: 99, value: paramMSB),
            CCMapper.makeCC(channel: ch, number: 98, value: paramLSB),
            CCMapper.makeCC(channel: ch, number: 6, value: valueMSB),
            CCMapper.makeCC(channel: ch, number: 38, value: valueLSB)
        ]
    }
}
