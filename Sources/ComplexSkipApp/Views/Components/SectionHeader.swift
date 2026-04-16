//
//  SectionHeader.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/SectionHeader.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct SectionHeader: View {
    let title: String
    let action: () -> Void
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button("See All", action: action)
                .font(.subheadline)
                .foregroundColor(.luxuryGold)
        }
        .padding(.horizontal)
    }
}
#endif
