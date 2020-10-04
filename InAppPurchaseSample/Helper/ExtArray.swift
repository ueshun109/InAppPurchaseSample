//
//  ExtArray.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/09/25.
//

import Foundation
import StoreKit

extension Array {
	var isNotEmpty: Bool { !self.isEmpty }
}

extension Array where Element == SKProduct {
	func toSmoothies() -> [Smoothie] {
		return self.map { product in
			return Smoothie(id: product.productIdentifier, title: product.localizedTitle, price: product.regularPrice ?? "0")
		}
	}
}

extension SKProduct {
	/// - returns: The cost of the product formatted in the local currency.
	var regularPrice: String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = self.priceLocale
		return formatter.string(from: self.price)
	}
}

extension SKProduct: Identifiable {
	
}
