// Models/Car.swift
import Foundation
import SkipFuse
import SkipFuseUI
#if !os(Android)
import CoreLocation
#endif

// SKIP @bridgeMembers
public struct Car: Identifiable, Codable, Hashable {
    public let id: UUID
    public let make: String
    public let model: String
    public let year: Int
    public let pricePerDay: Double
    public let pricePerWeek: Double
    public let pricePerMonth: Double
    public let horsepower: Int
    public let topSpeed: Int
    public let zeroToSixty: Double
    public let transmission: Transmission
    public let fuelType: FuelType
    public let seats: Int
    public let doors: Int
    public let luggage: Int
    public let rating: Double
    public let reviewCount: Int
    public let images: [String]
    public let features: [Feature]
    public let availability: AvailabilityStatus
    public let location: DealerLocation
    public let description: String
    public let colorOptions: [CarColor]
    public let insuranceOptions: [InsuranceOption]
    
    // SKIP @bridgeMembers
    public enum Transmission: String, Codable, CaseIterable {
        case automatic = "Automatic"
        case manual = "Manual"
        case dct = "DCT"
        case pdk = "PDK"
    }
    // SKIP @bridgeMembers
    public enum FuelType: String, Codable, CaseIterable {
        case gasoline = "Gasoline"
        case electric = "Electric"
        case hybrid = "Hybrid"
        case diesel = "Diesel"
    }
    // SKIP @bridgeMembers
    public enum AvailabilityStatus: String, Codable {
        case available = "Available Now"
        case reserved = "Reserved"
        case rented = "Currently Rented"
        case maintenance = "In Maintenance"
    }
    // SKIP @bridgeMembers
    public enum Feature: String, Codable, CaseIterable {
        case bluetooth = "Bluetooth"
        case navigation = "Navigation"
        case heatedSeats = "Heated Seats"
        case cooledSeats = "Cooled Seats"
        case sunroof = "Panoramic Sunroof"
        case premiumAudio = "Premium Audio"
        case appleCarPlay = "Apple CarPlay"
        case androidAuto = "Android Auto"
        case wirelessCharging = "Wireless Charging"
        case adaptiveCruise = "Adaptive Cruise Control"
        case laneAssist = "Lane Keep Assist"
        case blindSpot = "Blind Spot Monitor"
        case surroundCamera = "360° Camera"
        case headsUp = "Head-Up Display"
        case massageSeats = "Massage Seats"
        case airSuspension = "Air Suspension"
        case carbonCeramic = "Carbon Ceramic Brakes"
        case launch = "Launch Control"
    }
}
// SKIP @bridgeMembers
public struct CarColor: Codable, Hashable {
    public let name: String
    public let hexCode: String
    public let pricePremium: Double
    
    public init(name: String, hexCode: String, pricePremium: Double) {
        self.name = name
        self.hexCode = hexCode
        self.pricePremium = pricePremium
    }
}
// SKIP @bridgeMembers
public struct InsuranceOption: Codable, Hashable {
    public let type: InsuranceType
    public let name: String
    public let description: String
    public let pricePerDay: Double
    public let coverage: String
    
    // SKIP @bridgeMembers
    public enum InsuranceType: String, Codable {
        case basic = "Basic Coverage"
        case premium = "Premium Protection"
        case full = "Full Coverage"
        case luxury = "Luxury Protection"
    }
    
    public init(type: InsuranceType, name: String, description: String, pricePerDay: Double, coverage: String) {
        self.type = type
        self.name = name
        self.description = description
        self.pricePerDay = pricePerDay
        self.coverage = coverage
    }
}

// SKIP @bridgeMembers
public struct DealerLocation: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let address: String
    public let city: String
    public let state: String
    public let zipCode: String
    public let phone: String
    public let email: String
    public let hours: OperatingHours
    public let coordinates: Coordinates
    public let rating: Double
    public let images: [String]
    public let amenities: [String]
    
    public var fullAddress: String {
        "\(address), \(city), \(state) \(zipCode)"
    }
    
    public init(id: UUID, name: String, address: String, city: String, state: String, zipCode: String, phone: String, email: String, hours: OperatingHours, coordinates: Coordinates, rating: Double, images: [String], amenities: [String]) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.phone = phone
        self.email = email
        self.hours = hours
        self.coordinates = coordinates
        self.rating = rating
        self.images = images
        self.amenities = amenities
    }
}

// SKIP @bridgeMembers
public struct Coordinates: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    #if !os(Android)
    public var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    #endif
}

// SKIP @bridgeMembers
public struct OperatingHours: Codable, Hashable {
    public let monday: String
    public let tuesday: String
    public let wednesday: String
    public let thursday: String
    public let friday: String
    public let saturday: String
    public let sunday: String
    
    public init(monday: String, tuesday: String, wednesday: String, thursday: String, friday: String, saturday: String, sunday: String) {
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
    }
}
