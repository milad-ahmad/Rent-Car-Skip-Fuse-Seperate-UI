//
//  ExploreView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//
#if !os(Android)

import SkipFuse
import SkipFuseUI
// Views/ExploreView.swift
import SwiftUI

public struct ExploreView: View {
    @Environment(RentalViewModel.self) private var viewModel
    @State public var searchText = ""
    @State public var showingFilters = false
    @State public var selectedCategory: CarCategory = .all
    
    public enum CarCategory: String, CaseIterable {
        case all = "All"
        case sports = "Sports"
        case luxury = "Luxury"
        case suv = "SUV"
        case electric = "Electric"
        case convertible = "Convertible"
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Hero Section
                        HeroCarouselView(cars: viewModel.featuredCars)
                            .frame(height: 500)
                        
                        VStack(spacing: 24) {
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.textSecondary)
                                
                                TextField("Search for a car...", text: $searchText)
                                    .font(.body)
                                
                                Button(action: { showingFilters = true }) {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(.luxuryGold)
                                }
                            }
                            .padding()
                            .background(Color.surfacePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.05), radius: 10)
                            .padding(.horizontal)
                            
                            // Categories
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(CarCategory.allCases, id: \.self) { category in
                                        CategoryPill(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            withAnimation(.spring()) {
                                                selectedCategory = category
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Featured Section
                            SectionHeader(title: "Featured Vehicles", action: {})
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.featuredCars) { car in
                                        NavigationLink(destination: CarDetailView(car: car)) {
                                            FeaturedCarCard(car: car)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Popular Near You
                            SectionHeader(
                                title: "Popular Near You",
                                action: {}
                            )
                            
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.nearbyCars) { car in
                                    NavigationLink(destination: CarDetailView(car: car)) {
                                        CarListItem(car: car)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Membership Banner
                            MembershipBanner()
                                .padding()
                        }
                        .padding(.top, 24)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "steeringwheel")
                                .font(.title2)
                                .foregroundColor(.luxuryGold)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("LUXURY WHEELS")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.luxuryGold)
                            
                            Text("Premium Car Rental")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .foregroundColor(.textPrimary)
                        }
                        
                        NavigationLink(destination: ProfileView()) {
                            AsyncImage(url: URL(string: viewModel.currentUser?.profileImage ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(Color.surfaceSecondary)
                                    .overlay(
                                        Text(viewModel.currentUser?.name.prefix(1) ?? "G")
                                            .foregroundColor(.luxuryGold)
                                    )
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView()
                .environment(viewModel)
        }
    }
}
#endif
