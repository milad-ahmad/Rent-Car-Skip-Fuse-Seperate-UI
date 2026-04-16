//
//  FilterView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//
#if !os(Android)

import SkipFuse
import SkipFuseUI
// Views/FilterView.swift
import SwiftUI

public struct FilterView: View {
    @Environment(RentalViewModel.self) private var viewMode
    @Environment(\.dismiss) var dismiss
    @State public var minPrice: Double = 0
    @State public var maxPrice: Double = 5000
    @State public var selectedMakes: Set<String> = []
    @State public var selectedTransmission: Car.Transmission?
    @State public var minSeats: Int = 2
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Price Range") {
                    VStack {
                        HStack {
                            Text("Min: $\(Int(minPrice))")
                            Spacer()
                            Text("Max: $\(Int(maxPrice))")
                        }
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        
                        RangeSlider(minValue: $minPrice, maxValue: $maxPrice, bounds: 0...5000)
                    }
                }
                
                Section("Make") {
                    ForEach(["Ferrari", "Lamborghini", "Porsche", "Rolls-Royce", "Bentley", "McLaren"], id: \.self) { make in
                        HStack {
                            Text(make)
                            Spacer()
                            if selectedMakes.contains(make) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.luxuryGold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedMakes.contains(make) {
                                selectedMakes.remove(make)
                            } else {
                                selectedMakes.insert(make)
                            }
                        }
                    }
                }
                
                Section("Transmission") {
                    ForEach(Car.Transmission.allCases, id: \.self) { transmission in
                        HStack {
                            Text(transmission.rawValue)
                            Spacer()
                            if selectedTransmission == transmission {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.luxuryGold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTransmission = transmission
                        }
                    }
                }
                
                Section("Minimum Seats") {
                    Picker("Seats", selection: $minSeats) {
                        Text("2").tag(2)
                        Text("4").tag(4)
                        Text("5+").tag(5)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        minPrice = 0
                        maxPrice = 5000
                        selectedMakes.removeAll()
                        selectedTransmission = nil
                        minSeats = 2
                    }
                    .foregroundColor(.luxuryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        // Apply filters
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.luxuryGold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

// Custom Range Slider
public struct RangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let bounds: ClosedRange<Double>
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.surfaceSecondary)
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.luxuryGold)
                    .frame(width: CGFloat((maxValue - minValue) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width,
                           height: 4)
                    .offset(x: CGFloat((minValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width)
                
                Circle()
                    .fill(Color.luxuryGold)
                    .frame(width: 24, height: 24)
                    .offset(x: CGFloat((minValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = bounds.lowerBound + Double(value.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound)
                                minValue = min(max(newValue, bounds.lowerBound), maxValue - 100)
                            }
                    )
                
                Circle()
                    .fill(Color.luxuryGold)
                    .frame(width: 24, height: 24)
                    .offset(x: CGFloat((maxValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = bounds.lowerBound + Double(value.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound)
                                maxValue = max(min(newValue, bounds.upperBound), minValue + 100)
                            }
                    )
            }
        }
        .frame(height: 30)
    }
}
#endif
