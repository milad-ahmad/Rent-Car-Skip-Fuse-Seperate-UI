//
//  CarDetailView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//
#if !os(Android)

import SkipFuse
import SkipFuseUI
// Views/CarDetailView.swift
import SwiftUI

public struct CarDetailView: View {
    let car: Car
    @Environment(RentalViewModel.self) private var viewModel
    @State public var selectedColor: CarColor?
    @State public var selectedInsurance: InsuranceOption?
    @State public var showingBookingSheet = false
    @State public var selectedTab = 0
    @State public var showingImageGallery = false
    @State public var scrollOffset: CGFloat = 0
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    // Image Gallery
                    TabView {
                        ForEach(car.images, id: \.self) { imageSource in
                            AppImage(source: imageSource)
                                .onTapGesture {
                                    showingImageGallery = true
                                }
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(.page)
                    .frame(height: 300)
                    .tabViewStyle(.page)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(car.make)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    Text(car.model)
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.luxuryGold)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("$\(Int(car.pricePerDay))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("per day")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            
                            HStack {
                                RatingView(rating: car.rating, size: 16)
                                
                                Text("•")
                                    .foregroundColor(.textSecondary)
                                
                                Text("\(car.reviewCount) reviews")
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "heart")
                                        .font(.title3)
                                        .foregroundColor(.luxuryGold)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Quick Specs
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 24) {
                                SpecItem(icon: "speedometer", title: "Top Speed", value: "\(car.topSpeed) mph")
                                SpecItem(icon: "gauge.high", title: "0-60 mph", value: "\(String(format: "%.1f", car.zeroToSixty))s")
                                SpecItem(icon: "engine.combustion", title: "Horsepower", value: "\(car.horsepower) HP")
                                SpecItem(icon: "gearshift", title: "Transmission", value: car.transmission.rawValue)
                                SpecItem(icon: "fuelpump", title: "Fuel", value: car.fuelType.rawValue)
                                SpecItem(icon: "person.2", title: "Seats", value: "\(car.seats)")
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Description
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.headline)
                            
                            Text(car.description)
                                .font(.body)
                                .foregroundColor(.textSecondary)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)
                        
                        // Features
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Features & Amenities")
                                .font(.headline)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(car.features, id: \.self) { feature in
                                    HStack {
                                        Image(systemName: featureIcon(for: feature))
                                            .foregroundColor(.luxuryGold)
                                            .frame(width: 24)
                                        
                                        Text(feature.rawValue)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Color Options
                        if !car.colorOptions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Exterior Color")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(car.colorOptions, id: \.name) { color in
                                            ColorOptionView(
                                                color: color,
                                                isSelected: selectedColor?.name == color.name
                                            ) {
                                                selectedColor = color
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Insurance Options
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Insurance Protection")
                                .font(.headline)
                            
                            ForEach(car.insuranceOptions, id: \.type) { insurance in
                                InsuranceOptionView(
                                    insurance: insurance,
                                    isSelected: selectedInsurance?.type == insurance.type
                                ) {
                                    selectedInsurance = insurance
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Dealer Information
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pickup Location")
                                .font(.headline)
                            
                            DealerInfoCard(dealer: car.location)
                        }
                        .padding(.horizontal)
                        
                        // Reviews
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Reviews")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button("See All") {}
                                    .font(.subheadline)
                                    .foregroundColor(.luxuryGold)
                            }
                            
                            ForEach(0..<3) { _ in
                                ReviewCard()
                            }
                        }
                        .padding(.horizontal)
                        
                        // Similar Cars
                        VStack(alignment: .leading, spacing: 12) {
                            Text("You May Also Like")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.similarCars(to: car).prefix(4)) { similarCar in
                                        NavigationLink(destination: CarDetailView(car: similarCar)) {
                                            SimilarCarCard(car: similarCar)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 24)
                    .background(Color.backgroundPrimary)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Booking Bar
            VStack {
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(Int(car.pricePerDay))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.luxuryGold)
                        + Text(" / day")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        if let color = selectedColor {
                            Text("Color: \(color.name)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { showingBookingSheet = true }) {
                        Text("Continue to Book")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(Color.luxuryGold)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showingBookingSheet) {
            BookingView(
                car: car,
                selectedColor: selectedColor ?? car.colorOptions.first!,
                selectedInsurance: selectedInsurance
            )
            .environment(viewModel) 
        }
        .fullScreenCover(isPresented: $showingImageGallery) {
            ImageGalleryView(images: car.images)
        }
    }
    
    public func featureIcon(for feature: Car.Feature) -> String {
        switch feature {
        case .bluetooth: return "wave.3.right"
        case .navigation: return "location"
        case .heatedSeats: return "heat.waves"
        case .cooledSeats: return "snowflake"
        case .sunroof: return "sun.max"
        case .premiumAudio: return "hifispeaker"
        case .appleCarPlay: return "applelogo"
        case .androidAuto: return "androidlogo"
        case .wirelessCharging: return "battery.100.bolt"
        case .adaptiveCruise: return "car"
        case .laneAssist: return "arrow.left.and.right"
        case .blindSpot: return "eye"
        case .surroundCamera: return "camera"
        case .headsUp: return "rectangle.3.group"
        case .massageSeats: return "hand.wave"
        case .airSuspension: return "arrow.up.and.down"
        case .carbonCeramic: return "circle.dotted"
        case .launch: return "flag.checkered"
        }
    }
}
#endif
