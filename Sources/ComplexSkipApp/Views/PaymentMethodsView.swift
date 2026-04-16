//
//  PaymentMethodsView.swift
//  complex-skip-app
//
//  Created by Milad Ahmad on 09/04/2026.
//
#if !os(Android)


// Views/PaymentMethodsView.swift
import SwiftUI
import SkipFuse
import SkipFuseUI
public struct PaymentMethodsView: View {
    @Binding var selectedMethod: PaymentMethod?
    @Environment(\.dismiss) var dismiss
    @Environment(RentalViewModel.self) private var viewModel
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.currentUser?.paymentMethods ?? []) { method in
                    HStack {
                        PaymentMethodCard(method: method)
                            .onTapGesture {
                                selectedMethod = method
                                dismiss()
                            }
                        
                        if selectedMethod?.id == method.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.luxuryGold)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Add new payment method
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.luxuryGold)
                            Text("Add New Payment Method")
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
            }
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
#endif
