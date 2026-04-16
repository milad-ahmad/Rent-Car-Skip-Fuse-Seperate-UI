// Utilities/AppImage.swift
import SwiftUI
import SkipFuse
import SkipFuseUI

// SKIP @bridgeMembers
public struct AppImage: View {
    public let source: String
    public var contentMode: ContentMode = .fill
    
    public enum ContentMode {
        case fill, fit
    }
    
    public init(source: String, contentMode: ContentMode = .fill) {
        self.source = source
        self.contentMode = contentMode
    }
    
    // SKIP @bridgeMembers
    public var body: some View {
        if source.hasPrefix("http://") || source.hasPrefix("https://") {
            AsyncImage(url: URL(string: source)) { phase in
                switch phase {
                case .empty:
                    ProgressView().tint(.luxuryGold)
                case .success(let image):
                    configureImage(image)
                case .failure:
                    placeholderImage
                @unknown default:
                    placeholderImage
                }
            }
        } else {
            configureImage(Image(source))
        }
    }
    
    // SKIP @bridgeMembers
    @ViewBuilder
    public func configureImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode == .fill ? .fill : .fit)
    }
    // SKIP @bridgeMembers
    public var placeholderImage: some View {
        Rectangle()
            .fill(Color.surfaceSecondary)
            .overlay(
                Image(systemName: "car.fill")
                    .foregroundColor(.luxuryGold.opacity(0.5))
            )
    }
}
