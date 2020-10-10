//
//  CardViewModel.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/10/03.
//

import Foundation
import StoreKit
import Combine

final class CardViewModel: ObservableObject {
	@Published var unLock = false
	private let download: DownloadProduct
	private let purchase: PurchaseProduct
	private var anyPublisher: AnyCancellable?
	
	init(download: DownloadProduct, purchase: PurchaseProduct) {
		self.download = download
		self.purchase = purchase
		
		anyPublisher = self.purchase.subscribed.sink(receiveValue: { [weak self] subscribed in
			self?.unLock = subscribed
		})
	}
	
	func buy(product id: String) {
		download.delegate = self
		download(productIds: [id])
	}
}

extension CardViewModel: DownloadedProductNotification {
	func downloaded(products: [SKProduct]?, error: Error?) {
		download.delegate = nil
		guard let products = products, let product = products.first else {
			return
		}
		purchase.delegate = self
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
