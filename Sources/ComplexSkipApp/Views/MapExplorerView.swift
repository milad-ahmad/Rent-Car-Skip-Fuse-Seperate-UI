// Views/MapExplorerView.swift
#if !os(Android)

import SwiftUI
#if !os(Android)
import MapKit
#endif
import SkipFuse
import SkipFuseUI
public struct MapExplorerView: View {
    @Environment(RentalViewModel.self) private var viewModel
    @State internal var selectedCar: Car?
    @State internal var selectedDealer: DealerLocation?
    @State internal var showingCarSheet = false
    @State internal var showingDealerSheet = false
    
    #if !os(Android)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var isStandardStyle = true
    
    private var currentMapStyle: MapStyle {
        isStandardStyle ? .standard : .hybrid
    }
    #endif
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                #if !os(Android)
                Map(position: .constant(.region(region))) {
                    ForEach(viewModel.allDealers, id: \.id) { dealer in
                        Annotation(dealer.name, coordinate: dealer.coordinates.clLocation) {
                            DealerAnnotation(dealer: dealer)
                                .onTapGesture {
                                    selectedDealer = dealer
                                    showingDealerSheet = true
                                }
                        }
                    }
                    ForEach(viewModel.allCars.filter { $0.availability == .available }, id: \.id) { car in
                        Annotation(car.model, coordinate: car.location.coordinates.clLocation) {
                            CarAnnotation(car: car)
                                .onTapGesture {
                                    selectedCar = car
                                    showingCarSheet = true
                                }
                        }
                    }
                }
                .mapStyle(currentMapStyle)
                .mapControls {
                    MapCompass()
                    MapScaleView()
                    MapUserLocationButton()
                }
                
                VStack(spacing: 12) {
                    Button(action: { isStandardStyle.toggle() }) {
                        Image(systemName: isStandardStyle ? "map" : "globe.americas")
                            .font(.title3)
                            .foregroundColor(.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        if let userLocation = viewModel.userLocation {
                            region.center = userLocation
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.title3)
                            .foregroundColor(.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding()
                #else
                // Android fallback
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Nearby Dealers & Cars")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .padding(.top)
                        
                        ForEach(viewModel.allDealers, id: \.id) { dealer in
                            DealerInfoCard(dealer: dealer)
                                .onTapGesture {
                                    selectedDealer = dealer
                                    showingDealerSheet = true
                                }
                        }
                        
                        ForEach(viewModel.nearbyCars) { car in
                            CarListItem(car: car)
                                .onTapGesture {
                                    selectedCar = car
                                    showingCarSheet = true
                                }
                        }
                    }
                    .padding()
                }
                .background(Color.backgroundPrimary)
                #endif
            }
            .sheet(isPresented: $showingCarSheet) {
                if let car = selectedCar {
                    CarQuickView(car: car)
                        .environment(viewModel)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showingDealerSheet) {
                if let dealer = selectedDealer {
                    DealerDetailView(dealer: dealer)
                        .environment(viewModel)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

#if !os(Android)
struct DealerAnnotation: View {
    let dealer: DealerLocation
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.3)).frame(width: 40, height: 40)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                Image(systemName: "building.2.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            Image(systemName: "triangle.fill")
                .font(.system(size: 10))
                .foregroundColor(.blue)
                .offset(y: -2)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                isAnimating = true
            }
        }
    }
}

struct CarAnnotation: View {
    let car: Car
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle().fill(Color.luxuryGold.opacity(0.2)).frame(width: 40, height: 40)
                Image(systemName: "car.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.luxuryGold)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            Image(systemName: "triangle.fill")
                .font(.system(size: 10))
                .foregroundColor(.luxuryGold)
                .offset(y: -2)
        }
    }
}
#endif
#endif
