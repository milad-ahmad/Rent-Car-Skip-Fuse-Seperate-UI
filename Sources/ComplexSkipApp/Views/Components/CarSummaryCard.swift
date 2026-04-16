// Views/Components/CarSummaryCard.swift
#if !os(Android)

import SwiftUI
import SkipFuse
import SkipFuseUI
public struct CarSummaryCard: View {
    let car: Car
    let color: CarColor
    
    public var body: some View {
        HStack(spacing: 16) {
            AppImage(source: car.images.first ?? "")
                .frame(width: 80, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(car.year) \(car.make) \(car.model)")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: color.hexCode))
                        .frame(width: 12, height: 12)
                    Text(color.name)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                RatingView(rating: car.rating, size: 12)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
#endif
