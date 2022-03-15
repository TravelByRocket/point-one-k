//
//  SKProduct-LocalizedPrice.swift
//  PointOneK
//
//  Created by Bryan Costanza on 15 Mar 2022.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
