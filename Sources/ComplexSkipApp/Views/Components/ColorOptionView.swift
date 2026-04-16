//
//  ColorOptionView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/ColorOptionView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct ColorOptionView: View {
    let color: CarColor
    let isSelected: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(Color(hex: color.hexCode))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.luxuryGold, lineWidth: isSelected ? 3 : 0)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4)
                
                Text(color.name)
                    .font(.caption)
                    .foregroundColor(.textPrimary)
                
                if color.pricePremium > 0 {
                    Text("+$\(Int(color.pricePremium))")
                        .font(.caption2)
                        .foregroundColor(.luxuryGold)
                }
            }
        }
    }
}
#endif
