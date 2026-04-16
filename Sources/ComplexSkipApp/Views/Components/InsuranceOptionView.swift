//
//  InsuranceOptionView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/InsuranceOptionView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct InsuranceOptionView: View {
    let insurance: InsuranceOption
    let isSelected: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(insurance.name)
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(insurance.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("Coverage: \(insurance.coverage)")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(Int(insurance.pricePerDay))/day")
                        .font(.headline)
                        .foregroundColor(.luxuryGold)
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .luxuryGold : .textSecondary)
                }
            }
            .padding()
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.luxuryGold : Color.clear, lineWidth: 2)
            )
        }
    }
}
#endif
