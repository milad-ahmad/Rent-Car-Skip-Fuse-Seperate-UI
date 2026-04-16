// Views/DealerDetailView.swift
#if !os(Android)
import SwiftUI
import SkipFuse
import SkipFuseUI
#if !os(Android)
import MapKit
#endif

public struct DealerDetailView: View {
    let dealer: DealerLocation
    @Environment(\.dismiss) var dismiss
    
    #if !os(Android)
    @State private var region: MKCoordinateRegion
    #endif
    
    public init(dealer: DealerLocation) {
        self.dealer = dealer
        #if !os(Android)
        _region = State(initialValue: MKCoordinateRegion(
            center: dealer.coordinates.clLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
        #endif
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    #if !os(Android)
                    Map(position: .constant(.region(region))) {
                        Marker(dealer.name, coordinate: dealer.coordinates.clLocation)
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    #else
                    // Android: show a static image or placeholder
                    Rectangle()
                        .fill(Color.surfaceSecondary)
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "map")
                                    .font(.largeTitle)
                                Text("Map preview not available")
                            }
                            .foregroundColor(.textSecondary)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    #endif
                    
                    // ... rest of dealer info (unchanged)
                    
                    Button(action: openMaps) {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Get Directions")
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.luxuryGold)
                        .clipShape(Capsule())
                    }
                }
            }
            // ... toolbar
        }
    }
    
    private func openMaps() {
        #if !os(Android)
        let encodedAddress = dealer.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "maps://?q=\(encodedAddress)") {
            UIApplication.shared.open(url)
        }
        #else
        // Android: you can implement intent later
        print("Open maps on Android: \(dealer.fullAddress)")
        #endif
    }
    
    private func callDealer() {
        let phoneNumber = dealer.phone.filter { $0.isNumber }
        #if !os(Android)
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
        #else
        print("Call dealer: \(phoneNumber)")
        #endif
    }
}
#endif

