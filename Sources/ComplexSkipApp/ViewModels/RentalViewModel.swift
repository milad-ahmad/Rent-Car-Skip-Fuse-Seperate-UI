import SwiftUI
#if !os(Android)
import CoreLocation
#endif

@MainActor
@Observable
public final class RentalViewModel {
    public var allCars: [Car] = []
    public var allDealers: [DealerLocation] = []
    public var currentUser: UserProfile?
    
    private let dataService: RentalDataService
    
    #if !os(Android)
    public var userLocation: CLLocationCoordinate2D?
    public var locationManager: CLLocationManager?
    #else
    public var userLocation: (Double, Double)?
    #endif
    
    public init(dataService: RentalDataService = RentalDataService()) {
        self.dataService = dataService
        
        #if !os(Android)
        setupLocationManager()
        #endif
        
        loadData()
    }
    
    #if !os(Android)
    public func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        userLocation = locationManager?.location?.coordinate
    }
    #endif
    
    /**
     * Fetches required data from the data service and populates the view model state.
     */
    public func loadData() {
        let data = dataService.fetchMockData()
        self.allDealers = data.dealers
        self.allCars = data.cars
        self.currentUser = data.user
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
            return carLocation.distance(from: userLoc) < 50000
        }
        #else
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
