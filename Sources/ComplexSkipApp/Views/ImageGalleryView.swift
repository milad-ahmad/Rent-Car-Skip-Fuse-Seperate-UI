// Views/ImageGalleryView.swift
#if !os(Android)

import SwiftUI
import SkipFuse
import SkipFuseUI
public struct ImageGalleryView: View {
    let images: [String]
    @Environment(\.dismiss) var dismiss
    @State public var currentIndex = 0
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                TabView(selection: $currentIndex) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, imageSource in
                        AppImage(source: imageSource, contentMode: .fit)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("\(currentIndex + 1) of \(images.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.luxuryGold)
                }
            }
        }
    }
}
#endif
