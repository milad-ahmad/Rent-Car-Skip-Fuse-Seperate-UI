//
//  FeaturedCarCard.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/FeaturedCarCard.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct FeaturedCarCard: View {
    let car: Car
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AppImage(source: car.images.first ?? "")
                .frame(width: 280, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(width: 280, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(car.make)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                Text(car.model)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.luxuryGold)
                
                HStack {
                    RatingView(rating: car.rating, size: 12)
                    
                    Spacer()
                    
                    Text("$\(Int(car.pricePerDay))/day")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 280)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
#endif
