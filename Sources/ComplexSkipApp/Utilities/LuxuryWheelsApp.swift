// Utilities/ColorExtensions.swift
import SwiftUI
import SkipFuse
import SkipFuseUI

// SKIP @nobridge
public extension Color {
    static let luxuryGold = Color(hex: "D4AF37")
    static let backgroundPrimary = Color(hex: "0A0A0A")
    static let backgroundSecondary = Color(hex: "1A1A1A")
    static let surfacePrimary = Color(hex: "1C1C1E")
    static let surfaceSecondary = Color(hex: "2C2C2E")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "8E8E93")
    static let accentBlue = Color(hex: "0A84FF")
    static let accentGreen = Color(hex: "30D158")
    static let accentRed = Color(hex: "FF453A")
    // SKIP @nobridge
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
