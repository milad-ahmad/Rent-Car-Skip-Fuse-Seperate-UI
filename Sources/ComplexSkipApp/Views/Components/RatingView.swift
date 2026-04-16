//
//  RatingView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/RatingView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct RatingView: View {
    let rating: Double
    let size: CGFloat
    
    public var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(rating) ? "star.fill" : (index < Int(rating) + 1 && rating.truncatingRemainder(dividingBy: 1) >= 0.5 ? "star.leadinghalf.filled" : "star"))
                    .font(.system(size: size))
                    .foregroundColor(.luxuryGold)
            }
        }
    }
}
#endif
