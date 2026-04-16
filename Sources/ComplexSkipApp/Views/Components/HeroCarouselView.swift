//
//  HeroCarouselView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/Components/HeroCarouselView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct HeroCarouselView: View {
    let cars: [Car]
    @State internal var currentIndex = 0
    @State internal var timer: Timer?
    
    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(cars.enumerated()), id: \.element.id) { index, car in
                HeroCarCard(car: car)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            HStack(spacing: 8) {
                ForEach(0..<cars.count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.luxuryGold : Color.white.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .animation(.spring(), value: currentIndex)
                }
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    public func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % cars.count
            }
        }
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

public struct HeroCarCard: View {
    let car: Car
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            AppImage(source: car.images.first ?? "")
                .overlay(
                    LinearGradient(
                        colors: [.black.opacity(0.6), .clear, .black.opacity(0.4)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            .overlay(
                LinearGradient(
                    colors: [.black.opacity(0.6), .clear, .black.opacity(0.4)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Badge(text: car.availability.rawValue, color: .green)
                    Badge(text: "\(car.horsepower) HP", color: .luxuryGold)
                }
                
                Text(car.make)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(car.model)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(car.rating) ? "star.fill" : "star")
                            .foregroundColor(.luxuryGold)
                            .font(.caption)
                    }
                    
                    Text("(\(car.reviewCount) reviews)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("$\(Int(car.pricePerDay))/day")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.luxuryGold)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CarDetailView(car: car)) {
                        Text("Book Now")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.luxuryGold)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(24)
        }
    }
}
#endif
