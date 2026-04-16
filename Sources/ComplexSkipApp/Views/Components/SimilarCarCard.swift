// Views/Components/SimilarCarCard.swift
#if !os(Android)

import SwiftUI
import SkipFuse
import SkipFuseUI
public struct SimilarCarCard: View {
    let car: Car
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AppImage(source: car.images.first ?? "")
                .frame(width: 160, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(car.make)
                .font(.caption)
                .foregroundColor(.textSecondary)
            Text(car.model)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text("$\(Int(car.pricePerDay))/day")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.luxuryGold)
        }
        .frame(width: 160)
    }
}
#endif
