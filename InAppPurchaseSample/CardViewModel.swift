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
	}
	
	func buy(product: SKProduct) {
		self.purchase.delegate = self
		purchase(product: product)
	}
}

extension CardViewModel: PurchasedResultNotification {
	func completed(transaction: SKPaymentTransaction) {
		unLock = true
		self.purchase.delegate = nil
		SKPaymentQueue.default().finishTransaction(transaction)
	}
	
	func failed(transaction: SKPaymentTransaction) {
		self.purchase.delegate = nil
		SKPaymentQueue.default().finishTransaction(transaction)
	}
}
