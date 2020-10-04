//
//  HomeViewModel.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/10/03.
//

import Foundation
import Combine
import StoreKit

final class HomeViewModel: ObservableObject {
	@Published private(set) var smoothies: [SKProduct] = []
	
	private let download: DownloadProduct
	
	init(download: DownloadProduct) {
		self.download = download
		self.download.delegate = self
		self.download(productIds: Smoothie.allIDs)
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
		smoothies = products
	}
}
