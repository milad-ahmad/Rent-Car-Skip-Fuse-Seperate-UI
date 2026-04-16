//
//  PaymentMethodCard.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/PaymentMethodCard.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct PaymentMethodCard: View {
    let method: PaymentMethod
    
    public var iconName: String {
        switch method.type {
        case .visa: return "creditcard.fill"
        case .mastercard: return "creditcard.fill"
        case .amex: return "creditcard.fill"
        case .discover: return "creditcard.fill"
        }
    }
    
    public var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.luxuryGold)
            
            VStack(alignment: .leading) {
                Text("\(method.type.rawValue) •••• \(method.lastFour)")
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                Text("Expires \(method.expiryDate)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            if method.isDefault {
                Badge(text: "Default", color: .luxuryGold)
            }
            
            Image(systemName: "checkmark")
                .foregroundColor(.luxuryGold)
        }
        .padding()
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
#endif
