#if !os(Android)
import SwiftUI
import SkipFuse
import SkipFuseUI

/**
 * A carousel view that displays a paging list of featured cars.
 */
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
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
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
    
    /**
     * Starts the auto-scrolling timer for the carousel.
     */
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            Task { @MainActor in
                withAnimation {
                    currentIndex = (currentIndex + 1) % cars.count
                }
            }
        }
    }
    
    /**
     * Stops the auto-scrolling timer.
     */
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

/**
 * A card view representing a single car in the hero carousel, constrained by GeometryReader.
 */
public struct HeroCarCard: View {
    let car: Car
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                AppImage(source: car.images.first ?? "", contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.8), .black.opacity(0.2), .black.opacity(0.4)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                
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
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .frame(width: geometry.size.width, alignment: .leading)
            }
        }
    }
}
#endif
