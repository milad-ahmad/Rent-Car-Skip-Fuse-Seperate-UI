//
//  MyRentalsView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//
#if !os(Android)

import SkipFuse
import SkipFuseUI

// Views/MyRentalsView.swift
import SwiftUI

public struct MyRentalsView: View {
    @Environment(RentalViewModel.self) private var viewModel
    @State public var selectedSegment = 0
    
    public var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedSegment) {
                    Text("Upcoming").tag(0)
                    Text("Active").tag(1)
                    Text("Past").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if viewModel.currentUser?.rentalHistory.isEmpty ?? true {
                    EmptyRentalsView()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredRentals) { rental in
                                RentalCard(rental: rental)
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("My Rentals")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    public var filteredRentals: [Rental] {
        guard let rentals = viewModel.currentUser?.rentalHistory else { return [] }
        switch selectedSegment {
        case 0: return rentals.filter { $0.status == .upcoming }
        case 1: return rentals.filter { $0.status == .active }
        case 2: return rentals.filter { $0.status == .completed || $0.status == .cancelled }
        default: return rentals
        }
    }
}

public struct EmptyRentalsView: View {
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.fill")
                .font(.system(size: 60))
                .foregroundColor(.luxuryGold.opacity(0.5))
            
            Text("No Rentals Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your rental history will appear here")
                .foregroundColor(.textSecondary)
            
            NavigationLink(destination: ExploreView()) {
                Text("Browse Cars")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.luxuryGold)
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Views/MyRentalsView.swift (RentalCard struct only)
public struct RentalCard: View {
    let rental: Rental
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                AppImage(source: rental.car.images.first ?? "")
                    .frame(width: 80, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(rental.car.year) \(rental.car.make) \(rental.car.model)")
                        .font(.headline)
                    Text("Ref: \(rental.bookingReference)")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                StatusBadge(status: rental.status)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label(formatDate(rental.startDate), systemImage: "calendar")
                    Label(rental.pickupTime, systemImage: "clock")
                }
                .font(.caption)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.luxuryGold)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Label(formatDate(rental.endDate), systemImage: "calendar")
                    Label(rental.returnTime, systemImage: "clock")
                }
                .font(.caption)
            }
            .foregroundColor(.textSecondary)
            
            HStack {
                Text("Total: \(String(format: "$%.2f", rental.totalPrice))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View Details") {
                    // Action
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.luxuryGold)
            }
        }
        .padding()
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    public func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

public struct StatusBadge: View {
    let status: Rental.RentalStatus
    
    public var color: Color {
        switch status {
        case .upcoming: return .blue
        case .active: return .green
        case .completed: return .gray
        case .cancelled: return .red
        }
    }
    
    public  var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
#endif
