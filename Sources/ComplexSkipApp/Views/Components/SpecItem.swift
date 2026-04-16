//
//  SpecItem.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/SpecItem.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct SpecItem: View {
    let icon: String
    let title: String
    let value: String
    
    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.luxuryGold)
                .frame(width: 40, height: 40)
                .background(Color.luxuryGold.opacity(0.1))
                .clipShape(Circle())
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(width: 80)
    }
}
#endif
