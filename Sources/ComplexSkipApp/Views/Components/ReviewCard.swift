//
//  ReviewCard.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/ReviewCard.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct ReviewCard: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.surfaceSecondary)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("JD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.luxuryGold)
                    )
                
                VStack(alignment: .leading) {
                    Text("John D.")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    HStack {
                        RatingView(rating: 5.0, size: 12)
                        Text("2 days ago")
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            Text("Amazing experience! The car was in pristine condition and the staff was incredibly professional. Will definitely rent again.")
                .font(.body)
                .foregroundColor(.textSecondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
#endif
