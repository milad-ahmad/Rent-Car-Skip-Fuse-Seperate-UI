
// Views/Components/CarListItem.swift
#if !os(Android)

import SwiftUI
import SkipFuse
import SkipFuseUI
public struct CarListItem: View {
    let car: Car
    
    public var body: some View {
        HStack(spacing: 16) {
            AppImage(source: car.images.first ?? "")
                .frame(width: 100, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(car.year) \(car.make) \(car.model)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Badge(text: car.availability.rawValue, color: car.availability == .available ? .green : .orange)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    Text(car.location.city)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                HStack {
                    RatingView(rating: car.rating, size: 12)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(Int(car.pricePerDay))/day")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.luxuryGold)
                        Text("$\(Int(car.pricePerWeek))/week")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
#endif
