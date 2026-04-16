//
//  Badge.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/Badge.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct Badge: View {
    let text: String
    let color: Color
    
    public var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}
#endif
