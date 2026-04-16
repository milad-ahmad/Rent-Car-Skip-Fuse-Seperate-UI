//
//  ProfileView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//
#if !os(Android)


// Views/ProfileView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct ProfileView: View {
    @Environment(RentalViewModel.self) private var viewModel
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        AsyncImage(url: URL(string: viewModel.currentUser?.profileImage ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Color.surfaceSecondary)
                                .overlay(
                                    Text(viewModel.currentUser?.name.prefix(1).uppercased() ?? "G")
                                        .font(.largeTitle)
                                        .foregroundColor(.luxuryGold)
                                )
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.luxuryGold, lineWidth: 2)
                        )
                        
                        VStack(spacing: 4) {
                            Text(viewModel.currentUser?.name ?? "Guest User")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(tierColor)
                                Text(viewModel.currentUser?.membershipTier.rawValue ?? "Classic")
                                    .font(.subheadline)
                                    .foregroundColor(tierColor)
                            }
                            
                            Text("Member since \(formatDate(viewModel.currentUser?.memberSince ?? Date()))")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Balance Card
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Available Balance")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            Text("$\(String(format: "%.2f", viewModel.currentUser?.balance ?? 0))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.luxuryGold)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.addBonusCredits(500)
                        }) {
                            Text("Add Demo Funds")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.luxuryGold)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                    .background(Color.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Rewards Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Rewards Points")
                                .font(.headline)
                            Spacer()
                            Text("\(viewModel.currentUser?.rewards.points ?? 0) pts")
                                .font(.headline)
                                .foregroundColor(.luxuryGold)
                        }
                        
                        ProgressView(value: Double(viewModel.currentUser?.rewards.points ?? 0), total: Double(viewModel.currentUser?.rewards.nextTierPoints ?? 25000))
                            .tint(.luxuryGold)
                        
                        Text("\(viewModel.currentUser?.rewards.nextTierPoints ?? 25000) points to next tier")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Divider()
                        
                        ForEach(viewModel.currentUser?.rewards.benefits ?? []) { benefit in
                            HStack {
                                Image(systemName: benefit.icon)
                                    .foregroundColor(.luxuryGold)
                                    .frame(width: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(benefit.title)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text(benefit.description)
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Menu Options
                    VStack(spacing: 0) {
                        ProfileMenuRow(icon: "creditcard", title: "Payment Methods", value: "\(viewModel.currentUser?.paymentMethods.count ?? 0) cards")
                        Divider().background(Color.surfaceSecondary)
                        ProfileMenuRow(icon: "heart", title: "Saved Cars", value: "\(viewModel.currentUser?.savedCars.count ?? 0)")
                        Divider().background(Color.surfaceSecondary)
                        ProfileMenuRow(icon: "clock.arrow.circlepath", title: "Rental History", value: nil)
                        Divider().background(Color.surfaceSecondary)
                        ProfileMenuRow(icon: "gearshape", title: "Settings", value: nil)
                        Divider().background(Color.surfaceSecondary)
                        ProfileMenuRow(icon: "questionmark.circle", title: "Help & Support", value: nil)
                    }
                    .background(Color.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    public var tierColor: Color {
        switch viewModel.currentUser?.membershipTier {
        case .classic: return .gray
        case .silver: return Color(hex: "C0C0C0")
        case .gold: return .luxuryGold
        case .platinum: return Color(hex: "E5E4E2")
        case .black: return .black
        case .none: return .gray
        }
    }
    
    public func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

public struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let value: String?
    
    public var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.luxuryGold)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .foregroundColor(.textSecondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding()
    }
}
#endif
