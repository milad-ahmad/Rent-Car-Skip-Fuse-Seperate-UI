// Views/CarQuickView.swift
#if !os(Android)

import SwiftUI
import SkipFuse
import SkipFuseUI
public struct CarQuickView: View {
    let car: Car
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    AppImage(source: car.images.first ?? "")
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(car.make)
                                    .font(.title2)
                                Text(car.model)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.luxuryGold)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("$\(Int(car.pricePerDay))/day")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                RatingView(rating: car.rating, size: 14)
                            }
                        }
                        
                        HStack(spacing: 20) {
                            SpecItem(icon: "speedometer", title: "Top Speed", value: "\(car.topSpeed) mph")
                            SpecItem(icon: "gauge.high", title: "0-60", value: "\(String(format: "%.1f", car.zeroToSixty))s")
                            SpecItem(icon: "engine.combustion", title: "HP", value: "\(car.horsepower)")
                        }
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.luxuryGold)
                            Text(car.location.name)
                                .font(.subheadline)
                            Spacer()
                            Text(car.availability.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(car.availability == .available ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                .foregroundColor(car.availability == .available ? .green : .orange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: CarDetailView(car: car)) {
                        Text("View Full Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.luxuryGold)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Quick View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
#endif
