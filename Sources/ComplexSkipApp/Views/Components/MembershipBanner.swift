//
//  MembershipBanner.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/MembershipBanner.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct MembershipBanner: View {
    @Environment(RentalViewModel.self) private var viewModel
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.luxuryGold)
                    Text("\(viewModel.currentUser?.membershipTier.rawValue ?? "Classic") Member")
                        .font(.headline)
                        .foregroundColor(.luxuryGold)
                }
                
                Text("You have \(viewModel.currentUser?.rewards.points ?? 0) points")
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                
                ProgressView(value: Double(viewModel.currentUser?.rewards.points ?? 0), total: Double(viewModel.currentUser?.rewards.nextTierPoints ?? 25000))
                    .tint(.luxuryGold)
                    .frame(height: 4)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Next Tier")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                Text("\(viewModel.currentUser?.rewards.nextTierPoints ?? 25000) pts")
                    .font(.headline)
                    .foregroundColor(.luxuryGold)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.surfacePrimary, Color.surfaceSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.luxuryGold.opacity(0.3), lineWidth: 1)
        )
    }
}
#endif
