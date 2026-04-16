// ViewModels/RentalViewModel.swift
import SwiftUI
#if !os(Android)
import CoreLocation
#endif

// SKIP @bridgeMembers
@MainActor
@Observable
public final class RentalViewModel {
    public var allCars: [Car] = []
    public var allDealers: [DealerLocation] = []
    public var currentUser: UserProfile?
    
    // Platform-specific location storage
    #if !os(Android)
    public var userLocation: CLLocationCoordinate2D?
    public var locationManager: CLLocationManager?
    #else
    public var userLocation: (Double, Double)?
    #endif
    
    public init() {
        #if !os(Android)
        setupLocationManager()
        #endif
        loadMockData()
    }
    
    #if !os(Android)
    public func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        userLocation = locationManager?.location?.coordinate
    }
    #endif
    
    public func loadMockData() {
        // Create mock dealers
        let dealer1 = DealerLocation(
            id: UUID(),
            name: "Luxury Wheels Beverly Hills",
            address: "9420 Wilshire Blvd",
            city: "Beverly Hills",
            state: "CA",
            zipCode: "90212",
            phone: "(310) 555-0123",
            email: "beverly@luxurywheels.com",
            hours: OperatingHours(
                monday: "9:00 AM - 8:00 PM",
                tuesday: "9:00 AM - 8:00 PM",
                wednesday: "9:00 AM - 8:00 PM",
                thursday: "9:00 AM - 8:00 PM",
                friday: "9:00 AM - 9:00 PM",
                saturday: "10:00 AM - 7:00 PM",
                sunday: "11:00 AM - 6:00 PM"
            ),
            coordinates: Coordinates(latitude: 34.0673, longitude: -118.3994),
            rating: 4.9,
            images: ["dealer_beverly_1", "dealer_beverly_2"],
            amenities: ["Complimentary Coffee", "VIP Lounge", "Concierge Service", "Vehicle Delivery"]
        )
        
        let dealer2 = DealerLocation(
            id: UUID(),
            name: "Luxury Wheels Santa Monica",
            address: "1800 Ocean Ave",
            city: "Santa Monica",
            state: "CA",
            zipCode: "90401",
            phone: "(310) 555-0456",
            email: "santamonica@luxurywheels.com",
            hours: OperatingHours(
                monday: "8:00 AM - 8:00 PM",
                tuesday: "8:00 AM - 8:00 PM",
                wednesday: "8:00 AM - 8:00 PM",
                thursday: "8:00 AM - 8:00 PM",
                friday: "8:00 AM - 10:00 PM",
                saturday: "9:00 AM - 9:00 PM",
                sunday: "10:00 AM - 7:00 PM"
            ),
            coordinates: Coordinates(latitude: 34.0094, longitude: -118.4949),
            rating: 4.8,
            images: ["dealer_sm_1", "dealer_sm_2"],
            amenities: ["Ocean View Lounge", "Test Drive Route", "Electric Charging", "Car Wash"]
        )
        
        let dealer3 = DealerLocation(
            id: UUID(),
            name: "Luxury Wheels Downtown LA",
            address: "800 W Olympic Blvd",
            city: "Los Angeles",
            state: "CA",
            zipCode: "90015",
            phone: "(213) 555-0789",
            email: "dtla@luxurywheels.com",
            hours: OperatingHours(
                monday: "7:00 AM - 9:00 PM",
                tuesday: "7:00 AM - 9:00 PM",
                wednesday: "7:00 AM - 9:00 PM",
                thursday: "7:00 AM - 9:00 PM",
                friday: "7:00 AM - 11:00 PM",
                saturday: "8:00 AM - 11:00 PM",
                sunday: "9:00 AM - 8:00 PM"
            ),
            coordinates: Coordinates(latitude: 34.0449, longitude: -118.2649),
            rating: 4.7,
            images: ["dealer_dtla_1", "dealer_dtla_2"],
            amenities: ["24/7 Pickup", "Rooftop Lounge", "Valet Service", "Business Center"]
        )
        
        allDealers = [dealer1, dealer2, dealer3]
        
        // Create mock cars
        allCars = [
            Car(
                id: UUID(),
                make: "Ferrari",
                model: "SF90 Stradale",
                year: 2024,
                pricePerDay: 2499,
                pricePerWeek: 15750,
                pricePerMonth: 60000,
                horsepower: 986,
                topSpeed: 211,
                zeroToSixty: 2.5,
                transmission: .dct,
                fuelType: .hybrid,
                seats: 2,
                doors: 2,
                luggage: 2,
                rating: 4.9,
                reviewCount: 128,
                images: ["ferrari_sf90_1", "ferrari_sf90_2", "ferrari_sf90_3"],
                features: [.carbonCeramic, .launch, .surroundCamera, .premiumAudio, .appleCarPlay],
                availability: .available,
                location: dealer1,
                description: "Experience the pinnacle of Italian engineering with the Ferrari SF90 Stradale. This plug-in hybrid hypercar delivers breathtaking performance with its V8 engine and three electric motors producing nearly 1,000 horsepower.",
                colorOptions: [
                    CarColor(name: "Rosso Corsa", hexCode: "#FF2800", pricePremium: 0),
                    CarColor(name: "Giallo Modena", hexCode: "#FFD700", pricePremium: 500),
                    CarColor(name: "Blu Tour de France", hexCode: "#000080", pricePremium: 750)
                ],
                insuranceOptions: [
                    InsuranceOption(type: .basic, name: "Basic", description: "State minimum coverage", pricePerDay: 29, coverage: "$30k/$60k"),
                    InsuranceOption(type: .premium, name: "Premium", description: "Enhanced protection", pricePerDay: 59, coverage: "$100k/$300k"),
                    InsuranceOption(type: .luxury, name: "Luxury", description: "Full coverage with zero deductible", pricePerDay: 99, coverage: "$500k/$1M")
                ]
            ),
            Car(
                id: UUID(),
                make: "Lamborghini",
                model: "Revuelto",
                year: 2024,
                pricePerDay: 2799,
                pricePerWeek: 17500,
                pricePerMonth: 68000,
                horsepower: 1001,
                topSpeed: 217,
                zeroToSixty: 2.5,
                transmission: .dct,
                fuelType: .hybrid,
                seats: 2,
                doors: 2,
                luggage: 1,
                rating: 5.0,
                reviewCount: 89,
                images: ["lambo_revuelto_1", "lambo_revuelto_2"],
                features: [.launch, .carbonCeramic, .headsUp, .adaptiveCruise],
                availability: .available,
                location: dealer2,
                description: "The Lamborghini Revuelto represents a new era with its V12 hybrid powertrain. Aggressive styling meets revolutionary performance in this masterpiece of automotive design.",
                colorOptions: [
                    CarColor(name: "Verde Mantis", hexCode: "#74E39A", pricePremium: 0),
                    CarColor(name: "Arancio Argos", hexCode: "#FF6B00", pricePremium: 600),
                    CarColor(name: "Grigio Telesto", hexCode: "#6B6B6B", pricePremium: 800)
                ],
                insuranceOptions: [
                    InsuranceOption(type: .basic, name: "Basic", description: "State minimum coverage", pricePerDay: 35, coverage: "$30k/$60k"),
                    InsuranceOption(type: .premium, name: "Premium", description: "Enhanced protection", pricePerDay: 69, coverage: "$100k/$300k"),
                    InsuranceOption(type: .luxury, name: "Luxury", description: "Full coverage with zero deductible", pricePerDay: 119, coverage: "$500k/$1M")
                ]
            ),
            Car(
                id: UUID(),
                make: "Rolls-Royce",
                model: "Spectre",
                year: 2024,
                pricePerDay: 1899,
                pricePerWeek: 11900,
                pricePerMonth: 45000,
                horsepower: 577,
                topSpeed: 155,
                zeroToSixty: 4.4,
                transmission: .automatic,
                fuelType: .electric,
                seats: 4,
                doors: 2,
                luggage: 3,
                rating: 4.8,
                reviewCount: 67,
                images: ["rolls_spectre_1", "rolls_spectre_2"],
                features: [.massageSeats, .airSuspension, .premiumAudio, .wirelessCharging],
                availability: .available,
                location: dealer1,
                description: "The first all-electric Rolls-Royce delivers serene luxury with instant torque. Experience the future of ultra-luxury motoring in complete silence.",
                colorOptions: [
                    CarColor(name: "Arctic White", hexCode: "#FFFFFF", pricePremium: 0),
                    CarColor(name: "Midnight Sapphire", hexCode: "#191970", pricePremium: 1000),
                    CarColor(name: "Morganite", hexCode: "#FFB6C1", pricePremium: 1200)
                ],
                insuranceOptions: [
                    InsuranceOption(type: .basic, name: "Basic", description: "State minimum coverage", pricePerDay: 45, coverage: "$30k/$60k"),
                    InsuranceOption(type: .premium, name: "Premium", description: "Enhanced protection", pricePerDay: 79, coverage: "$100k/$300k"),
                    InsuranceOption(type: .luxury, name: "Luxury", description: "Full coverage with zero deductible", pricePerDay: 149, coverage: "$500k/$1M")
                ]
            ),
            Car(
                id: UUID(),
                make: "Porsche",
                model: "911 Turbo S",
                year: 2024,
                pricePerDay: 1299,
                pricePerWeek: 8000,
                pricePerMonth: 31000,
                horsepower: 640,
                topSpeed: 205,
                zeroToSixty: 2.6,
                transmission: .pdk,
                fuelType: .gasoline,
                seats: 4,
                doors: 2,
                luggage: 2,
                rating: 4.9,
                reviewCount: 245,
                images: ["porsche_turbo_1", "porsche_turbo_2"],
                features: [.carbonCeramic, .appleCarPlay],
                availability: .available,
                location: dealer3,
                description: "The iconic 911 Turbo S combines everyday usability with supercar performance. Porsche's legendary engineering shines in this all-weather sports car.",
                colorOptions: [
                    CarColor(name: "GT Silver", hexCode: "#C0C0C0", pricePremium: 0),
                    CarColor(name: "Carmine Red", hexCode: "#960018", pricePremium: 300),
                    CarColor(name: "Gentian Blue", hexCode: "#000080", pricePremium: 300)
                ],
                insuranceOptions: [
                    InsuranceOption(type: .basic, name: "Basic", description: "State minimum coverage", pricePerDay: 25, coverage: "$30k/$60k"),
                    InsuranceOption(type: .premium, name: "Premium", description: "Enhanced protection", pricePerDay: 49, coverage: "$100k/$300k"),
                    InsuranceOption(type: .full, name: "Full Coverage", description: "Complete protection", pricePerDay: 89, coverage: "$300k/$500k")
                ]
            ),
            Car(
                id: UUID(),
                make: "Bentley",
                model: "Continental GT Speed",
                year: 2024,
                pricePerDay: 1599,
                pricePerWeek: 10000,
                pricePerMonth: 38000,
                horsepower: 650,
                topSpeed: 208,
                zeroToSixty: 3.5,
                transmission: .dct,
                fuelType: .gasoline,
                seats: 4,
                doors: 2,
                luggage: 3,
                rating: 4.7,
                reviewCount: 156,
                images: ["bentley_gt_1", "bentley_gt_2"],
                features: [.massageSeats, .airSuspension, .premiumAudio],
                availability: .available,
                location: dealer2,
                description: "The Continental GT Speed perfectly balances luxury and performance. Handcrafted interior meets 650 horsepower for an unforgettable grand touring experience.",
                colorOptions: [
                    CarColor(name: "Beluga", hexCode: "#1A1A1A", pricePremium: 0),
                    CarColor(name: "Orange Flame", hexCode: "#FF4500", pricePremium: 400),
                    CarColor(name: "Sequin Blue", hexCode: "#4169E1", pricePremium: 500)
                ],
                insuranceOptions: [
                    InsuranceOption(type: .basic, name: "Basic", description: "State minimum coverage", pricePerDay: 35, coverage: "$30k/$60k"),
                    InsuranceOption(type: .premium, name: "Premium", description: "Enhanced protection", pricePerDay: 65, coverage: "$100k/$300k"),
                    InsuranceOption(type: .luxury, name: "Luxury", description: "Full coverage with zero deductible", pricePerDay: 129, coverage: "$500k/$1M")
                ]
            ),
            Car(
                id: UUID(),
                make: "McLaren",
                model: "Artura",
                year: 2024,
                pricePerDay: 1899,
                pricePerWeek: 11900,
                pricePerMonth: 45000,
                horsepower: 671,
                topSpeed: 205,
                zeroToSixty: 3.0,
                transmission: .dct,
                fuelType: .hybrid,
                seats: 2,
                doors: 2,
                luggage: 1,
                rating: 4.8,
                reviewCount: 92,
                images: ["mclaren_artura_1", "mclaren_artura_2"],
                features: [.carbonCeramic, .launch],
                availability: .available,
                location: dealer3,
                description: "McLaren's first series-production hybrid supercar combines Formula 1 technology with everyday usability. Lightweight carbon fiber construction delivers pure driving engagement.",
                colorOptions: [
                    CarColor(name: "McLaren Orange", hexCode: "#FF5E00", pricePremium: 0),
                    CarColor(name: "Flux Silver", hexCode: "#C0C0C0", pricePremium: 700),
                    CarColor(name: "Ember Red", hexCode: "#8B0000", pricePremium: 800)
                ],
                insuranceOptions: [
                    InsuranceOption(type: .basic, name: "Basic", description: "State minimum coverage", pricePerDay: 39, coverage: "$30k/$60k"),
                    InsuranceOption(type: .premium, name: "Premium", description: "Enhanced protection", pricePerDay: 69, coverage: "$100k/$300k"),
                    InsuranceOption(type: .luxury, name: "Luxury", description: "Full coverage with zero deductible", pricePerDay: 139, coverage: "$500k/$1M")
                ]
            )
        ]
        
        // Create mock user with fake money
        currentUser = UserProfile(
            id: UUID(),
            name: "Guest User",
            email: "guest@luxurywheels.com",
            phone: "(555) 123-4567",
            profileImage: nil,
            memberSince: Date(),
            membershipTier: .gold,
            savedCars: [],
            recentSearches: [],
            paymentMethods: [
                PaymentMethod(
                    id: UUID(),
                    type: .amex,
                    lastFour: "1000",
                    expiryDate: "12/28",
                    isDefault: true
                ),
                PaymentMethod(
                    id: UUID(),
                    type: .visa,
                    lastFour: "4242",
                    expiryDate: "09/26",
                    isDefault: false
                )
            ],
            rentalHistory: [],
            balance: 25000, // Fake money for demo
            rewards: Rewards(
                points: 12500,
                nextTierPoints: 25000,
                benefits: [
                    Benefit(id: UUID(), title: "Priority Support", description: "24/7 dedicated concierge", icon: "headphones"),
                    Benefit(id: UUID(), title: "Free Upgrades", description: "Complimentary vehicle upgrades when available", icon: "arrow.up.circle")
                ]
            )
        )
    }
    
    public var featuredCars: [Car] {
        Array(allCars.filter { $0.rating >= 4.8 }.prefix(3))
    }
    
    public var nearbyCars: [Car] {
        #if !os(Android)
        guard let userLocation = userLocation else { return Array(allCars.prefix(5)) }
        return allCars.filter { car in
            let carLocation = CLLocation(latitude: car.location.coordinates.latitude,
                                         longitude: car.location.coordinates.longitude)
            let userLoc = CLLocation(latitude: userLocation.latitude,
                                     longitude: userLocation.longitude)
            return carLocation.distance(from: userLoc) < 50000 // Within 50km
        }
        #else
        // On Android, just return a reasonable subset
        return Array(allCars.prefix(10))
        #endif
    }
    
    public func similarCars(to car: Car) -> [Car] {
        allCars.filter { $0.id != car.id && $0.make == car.make }
    }
    
    public func createRental(car: Car, startDate: Date, endDate: Date, totalPrice: Double,
                             insurance: InsuranceOption?, color: CarColor, paymentMethod: PaymentMethod) {
        let rental = Rental(
            id: UUID(),
            car: car,
            dealer: car.location,
            startDate: startDate,
            endDate: endDate,
            pickupTime: "10:00 AM",
            returnTime: "10:00 AM",
            totalPrice: totalPrice,
            status: .upcoming,
            insurance: insurance,
            selectedColor: color,
            paymentMethod: paymentMethod,
            bookingReference: generateBookingReference()
        )
        
        currentUser?.rentalHistory.append(rental)
        currentUser?.balance -= totalPrice
    }
    
    public func addBonusCredits(_ amount: Double) {
        currentUser?.balance += amount
    }
    
    public func generateBookingReference() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in letters.randomElement()! })
    }
}
