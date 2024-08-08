//
//  OrderView.swift
//  ToDoList
//
//  Created by Aditya Medhane on 07/08/24.
//

import SwiftUI

struct OrderConfirmationView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "a.square.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Spacer()
                    Text("Order No : O123123123")
                        .font(.footnote)
                }
                
                Text("Yay! Your Order Is Confirmed")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Hi Anisha")
                    .font(.title2)
                
                Text("Thank you for your order. We will send you a confirmation when your order ships. Please find below the receipt of your purchase.")
                    .font(.body)
                    .padding(.bottom, 20)
                
                // Order Items
                ForEach(["Women's Running Shoe", "Men's Running Shoe"], id: \.self) { item in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "shoe")
                                .resizable()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text(item)
                                    .font(.headline)
                                Text("Quantity: 1")
                                Text("Color: \(item.hasPrefix("Women") ? "Blue" : "Black")")
                                Text("Size: M")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(item.hasPrefix("Women") ? "13/07/2020" : "18/07/2020")
                                Text("₹ 1200.00")
                            }
                        }
                        Divider()
                    }
                }
                
                // Totals
                VStack(spacing: 10) {
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text("₹ 2400.00")
                    }
                    HStack {
                        Text("Shipping Charges:")
                        Spacer()
                        Text("₹ 100.00")
                    }
                    HStack {
                        Text("Grand Total:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("₹ 2500.00")
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical)

                Divider()

                // Addresses
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Shipping Address:")
                            .font(.headline)
                        Text("No - 10 A, Street Name, Area Name,\nCity Name, State Name, Country.")
                            .font(.body)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Billing Address:")
                            .font(.headline)
                        Text("No - 10 A, Street Name, Area Name,\nCity Name, State Name, Country.")
                            .font(.body)
                    }
                }
                .padding(.vertical)

                // Footer
                Text("Hope to see you soon,")
                Text("Amazon Team")
                    .fontWeight(.bold)

                Button(action: {
                    // Add action here
                }) {
                    Text("Contact our Support Team")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
                .padding(.top, 20)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
    }
}

struct OrderConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        OrderConfirmationView()
    }
}
