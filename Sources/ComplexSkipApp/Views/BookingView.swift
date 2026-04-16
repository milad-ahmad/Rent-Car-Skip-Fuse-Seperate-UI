//
//  BookingView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//

#if !os(Android)

// Views/BookingView.swift
import SwiftUI

public struct BookingView: View {
    let car: Car
    let selectedColor: CarColor
    let selectedInsurance: InsuranceOption?
    @Environment(RentalViewModel.self) private var viewModel
    
    @Environment(\.dismiss) var dismiss
    @State public var startDate = Date()
    @State public var endDate = Date().addingTimeInterval(86400 * 3)
    @State public var pickupTime = "10:00 AM"
    @State public var returnTime = "10:00 AM"
    @State public var selectedPaymentMethod: PaymentMethod?
    @State public var showingPaymentSheet = false
    @State public var agreeToTerms = false
    @State public var showingConfirmation = false
    @State public var promoCode = ""
    @State public var appliedPromo: PromoCode?
    
    public var rentalDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
    }
    
    public var subtotal: Double {
        car.pricePerDay * Double(rentalDays)
    }
    
    public var insuranceCost: Double {
        (selectedInsurance?.pricePerDay ?? 0) * Double(rentalDays)
    }
    
    public var colorPremium: Double {
        selectedColor.pricePremium
    }
    
    public var promoDiscount: Double {
        guard let promo = appliedPromo else { return 0 }
        return subtotal * (promo.discountPercentage / 100)
    }
    
    public var taxes: Double {
        subtotal * 0.0825
    }
    
    public var total: Double {
        subtotal + insuranceCost + colorPremium + taxes - promoDiscount
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Car Summary
                    CarSummaryCard(car: car, color: selectedColor)
                    
                    // Rental Period
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Rental Period")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            DatePicker("Pickup Date", selection: $startDate, in: Date()..., displayedComponents: .date)
                            
                            HStack {
                                Text("Pickup Time")
                                Spacer()
                                Picker("", selection: $pickupTime) {
                                    ForEach(timeSlots, id: \.self) { time in
                                        Text(time).tag(time)
                                    }
                                }
                            }
                            
                            Divider()
                            
                            DatePicker("Return Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                            
                            HStack {
                                Text("Return Time")
                                Spacer()
                                Picker("", selection: $returnTime) {
                                    ForEach(timeSlots, id: \.self) { time in
                                        Text(time).tag(time)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.surfacePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    
                    // Price Breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Price Details")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            PriceRow(title: "\(car.make) \(car.model) × \(rentalDays) days", amount: subtotal)
                            
                            if colorPremium > 0 {
                                PriceRow(title: "Color: \(selectedColor.name)", amount: colorPremium)
                            }
                            
                            if let insurance = selectedInsurance {
                                PriceRow(title: "Insurance: \(insurance.name)", amount: insuranceCost)
                            }
                            
                            if let promo = appliedPromo {
                                HStack {
                                    Text("Promo: \(promo.code)")
                                        .foregroundColor(.green)
                                    Spacer()
                                    Text("-\(String(format: "$%.2f", promoDiscount))")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            PriceRow(title: "Taxes & Fees", amount: taxes)
                            
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "$%.2f", total))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.luxuryGold)
                            }
                        }
                        .padding()
                        .background(Color.surfacePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    
                    // Promo Code
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Promo Code")
                            .font(.headline)
                        
                        HStack {
                            TextField("Enter promo code", text: $promoCode)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Apply") {
                                applyPromoCode()
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.luxuryGold)
                            .disabled(promoCode.isEmpty)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Payment Method
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Payment Method")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button("Change") {
                                showingPaymentSheet = true
                            }
                            .foregroundColor(.luxuryGold)
                        }
                        
                        if let payment = selectedPaymentMethod {
                            PaymentMethodCard(method: payment)
                        } else {
                            Button(action: { showingPaymentSheet = true }) {
                                HStack {
                                    Image(systemName: "creditcard")
                                    Text("Add Payment Method")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.surfacePrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Terms & Conditions
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $agreeToTerms) {
                            HStack(spacing: 4) {
                                Text("I agree to the")
                                Button("Terms & Conditions") {}
                                    .foregroundColor(.luxuryGold)
                                Text("and")
                                Button("Rental Agreement") {}
                                    .foregroundColor(.luxuryGold)
                            }
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Book Button
                    Button(action: processBooking) {
                        HStack {
                            Text("Confirm & Pay")
                            Image(systemName: "lock.fill")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            canBook ? Color.luxuryGold : Color.gray
                        )
                        .clipShape(Capsule())
                    }
                    .disabled(!canBook)
                    .padding()
                }
                .padding(.vertical)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Book Your Rental")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingPaymentSheet) {
                PaymentMethodsView(selectedMethod: $selectedPaymentMethod)
            }
            .alert("Booking Confirmed", isPresented: $showingConfirmation) {
                Button("View My Rentals") {
                    dismiss()
                }
                Button("Done") {
                    dismiss()
                }
            } message: {
                Text("Your \(car.make) \(car.model) is ready! Check-in details have been sent to your email.")
            }
        }
    }
    
    public var timeSlots: [String] {
        [
            "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
            "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM",
            "6:00 PM", "7:00 PM", "8:00 PM"
        ]
    }
    
    public var canBook: Bool {
        selectedPaymentMethod != nil && agreeToTerms && rentalDays > 0
    }
    
    public func applyPromoCode() {
        // Simulate promo code validation
        if promoCode.uppercased() == "LUXURY20" {
            appliedPromo = PromoCode(
                code: "LUXURY20",
                discountPercentage: 20,
                description: "20% off your rental"
            )
        } else if promoCode.uppercased() == "FIRST10" {
            appliedPromo = PromoCode(
                code: "FIRST10",
                discountPercentage: 10,
                description: "10% off first rental"
            )
        }
    }
    
    public func processBooking() {
        viewModel.createRental(
            car: car,
            startDate: startDate,
            endDate: endDate,
            totalPrice: total,
            insurance: selectedInsurance,
            color: selectedColor,
            paymentMethod: selectedPaymentMethod!
        )
        
        // Add fake money to account for demo
        viewModel.addBonusCredits(500)
        
        showingConfirmation = true
    }
}

public struct PromoCode {
    let code: String
    let discountPercentage: Double
    let description: String
}
#endif
