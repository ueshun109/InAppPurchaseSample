//
//  CardViewModel.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/10/03.
//

import Foundation
import StoreKit

final class CardViewModel: ObservableObject {
	@Published var unLock = false
	private let purchase: PurchaseProduct
	
	init(purchase: PurchaseProduct) {
		self.purchase = purchase
		self.purchase.delegate = self
	}
	
	func buy(product: SKProduct) {
		unLock = true
//		purchase(product: product)
	}
}

extension CardViewModel: PurchasedResultNotification {
	func completed(transaction: SKPaymentTransaction) {
		unLock = true
		print("complete")
	}
	
	func failed(transaction: SKPaymentTransaction) {
		print("failed")
	}
}
