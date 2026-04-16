//
//  CategoryPill.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/CategoryPill.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct CategoryPill: View {
    let category: ExploreView.CarCategory
    let isSelected: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .black : .textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.luxuryGold : Color.surfacePrimary)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.luxuryGold.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}
#endif
