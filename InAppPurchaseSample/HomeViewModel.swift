//
//  HomeViewModel.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/10/03.
//

import Foundation
import Combine
import StoreKit

class Subscription {
	var subscribed = false
}

final class HomeViewModel: ObservableObject {
	let smoothies = Smoothie.all
	@Published private(set) var subscription = Subscription()
	
	private let download: DownloadProduct
	private let purchase: PurchaseProduct
	
	init(download: DownloadProduct, purchase: PurchaseProduct) {
		self.download = download
		self.purchase = purchase
	}
	
	func startSubscription() {
		download.delegate = self
		download(productIds: ["all.drinking"])
	}
}

extension HomeViewModel: DownloadedProductNotification {
	func downloaded(products: [SKProduct]?, error: Error?) {
		if let error = error {
			print(error.localizedDescription)
			return
		}
		guard let products = products else {
			print("products is empty")
			return
		}
		if let product = products.first, product.productIdentifier == "all.drinking" {
			purchase.delegate = self
			purchase(product: product)
		}
	}
}

extension HomeViewModel: PurchasedResultNotification {
	func completed(transaction: SKPaymentTransaction) {
		subscription.subscribed = true
		download.delegate = nil
		purchase.delegate = nil
		SKPaymentQueue.default().finishTransaction(transaction)
	}
	
	func failed(transaction: SKPaymentTransaction) {
		download.delegate = nil
		purchase.delegate = nil
		SKPaymentQueue.default().finishTransaction(transaction)
	}
}
