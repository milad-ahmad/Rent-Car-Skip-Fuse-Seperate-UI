//
//  PriceRow.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/PriceRow.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct PriceRow: View {
    let title: String
    let amount: Double
    
    public var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(String(format: "$%.2f", amount))
                .foregroundColor(.textPrimary)
        }
        .font(.subheadline)
    }
}
#endif
