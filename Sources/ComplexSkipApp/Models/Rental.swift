// Models/Rental.swift
import Foundation
import SkipFuse
import SkipFuseUI

// SKIP @bridgeMembers
public struct Rental: Identifiable, Codable {
    public let id: UUID
    public let car: Car
    public let dealer: DealerLocation
    public let startDate: Date
    public let endDate: Date
    public let pickupTime: String
    public let returnTime: String
    public let totalPrice: Double
    public let status: RentalStatus
    public let insurance: InsuranceOption?
    public let selectedColor: CarColor
    public let paymentMethod: PaymentMethod
    public let bookingReference: String
    
    // SKIP @bridgeMembers
    public enum RentalStatus: String, Codable {
        case upcoming = "Upcoming"
        case active = "Active"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }
    
    public var rentalDuration: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
    }
    
    public init(id: UUID, car: Car, dealer: DealerLocation, startDate: Date, endDate: Date, pickupTime: String, returnTime: String, totalPrice: Double, status: RentalStatus, insurance: InsuranceOption?, selectedColor: CarColor, paymentMethod: PaymentMethod, bookingReference: String) {
        self.id = id
        self.car = car
        self.dealer = dealer
        self.startDate = startDate
        self.endDate = endDate
        self.pickupTime = pickupTime
        self.returnTime = returnTime
        self.totalPrice = totalPrice
        self.status = status
        self.insurance = insurance
        self.selectedColor = selectedColor
        self.paymentMethod = paymentMethod
        self.bookingReference = bookingReference
    }
}

// SKIP @bridgeMembers
public struct PaymentMethod: Codable, Hashable, Identifiable {
    public let id: UUID
    public let type: PaymentType
    public let lastFour: String
    public let expiryDate: String
    public let isDefault: Bool
    
    // SKIP @bridgeMembers
    public enum PaymentType: String, Codable {
        case visa = "Visa"
        case mastercard = "Mastercard"
        case amex = "American Express"
        case discover = "Discover"
    }
    
    public init(id: UUID, type: PaymentType, lastFour: String, expiryDate: String, isDefault: Bool) {
        self.id = id
        self.type = type
        self.lastFour = lastFour
        self.expiryDate = expiryDate
        self.isDefault = isDefault
    }
}

// SKIP @bridgeMembers
public struct UserProfile: Codable {
    public var id: UUID
    public var name: String
    public var email: String
    public var phone: String
    public var profileImage: String?
    public var memberSince: Date
    public var membershipTier: MembershipTier
    public var savedCars: [UUID]
    public var recentSearches: [SearchHistory]
    public var paymentMethods: [PaymentMethod]
    public var rentalHistory: [Rental]
    public var balance: Double
    public var rewards: Rewards
    
    // SKIP @bridgeMembers
    public enum MembershipTier: String, Codable {
        case classic = "Classic"
        case silver = "Silver"
        case gold = "Gold"
        case platinum = "Platinum"
        case black = "Black"
    }
    
    public init(id: UUID, name: String, email: String, phone: String, profileImage: String?, memberSince: Date, membershipTier: MembershipTier, savedCars: [UUID], recentSearches: [SearchHistory], paymentMethods: [PaymentMethod], rentalHistory: [Rental], balance: Double, rewards: Rewards) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.profileImage = profileImage
        self.memberSince = memberSince
        self.membershipTier = membershipTier
        self.savedCars = savedCars
        self.recentSearches = recentSearches
        self.paymentMethods = paymentMethods
        self.rentalHistory = rentalHistory
        self.balance = balance
        self.rewards = rewards
    }
}

// SKIP @bridgeMembers
public struct SearchHistory: Codable, Hashable {
    public let query: String
    public let timestamp: Date
    public let filters: SearchFilters?
    
    public init(query: String, timestamp: Date, filters: SearchFilters?) {
        self.query = query
        self.timestamp = timestamp
        self.filters = filters
    }
}

// SKIP @bridgeMembers
public struct SearchFilters: Codable, Hashable {
    public var minPrice: Double?
    public var maxPrice: Double?
    public var makes: [String]?
    public var transmission: Car.Transmission?
    public var minSeats: Int?
    public var features: [Car.Feature]?
    
    public init(minPrice: Double? = nil, maxPrice: Double? = nil, makes: [String]? = nil, transmission: Car.Transmission? = nil, minSeats: Int? = nil, features: [Car.Feature]? = nil) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.makes = makes
        self.transmission = transmission
        self.minSeats = minSeats
        self.features = features
    }
}

// SKIP @bridgeMembers
public struct Rewards: Codable {
    public var points: Int
    public var nextTierPoints: Int
    public var benefits: [Benefit]
    
    public init(points: Int, nextTierPoints: Int, benefits: [Benefit]) {
        self.points = points
        self.nextTierPoints = nextTierPoints
        self.benefits = benefits
    }
}

// SKIP @bridgeMembers
public struct Benefit: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let icon: String
    
    public init(id: UUID, title: String, description: String, icon: String) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
    }
}
