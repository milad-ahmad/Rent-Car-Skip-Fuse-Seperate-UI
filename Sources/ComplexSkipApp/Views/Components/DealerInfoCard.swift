//
//  DealerInfoCard.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/DealerInfoCard.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct DealerInfoCard: View {
    let dealer: DealerLocation
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.luxuryGold)
                Text(dealer.name)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                RatingView(rating: dealer.rating, size: 14)
            }
            
            Text(dealer.fullAddress)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            HStack {
                Label(dealer.phone, systemImage: "phone.fill")
                Spacer()
                Label("Open until 8 PM", systemImage: "clock.fill")
            }
            .font(.caption)
            .foregroundColor(.textSecondary)
            
            // Directions button
            Button(action: {
                openMaps()
            }) {
                HStack {
                    Image(systemName: "map.fill")
                    Text("Get Directions")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.luxuryGold)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    public func openMaps() {
        let encodedAddress = dealer.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "maps://?q=\(encodedAddress)") {
            UIApplication.shared.open(url)
        }
    }
}
#endif
