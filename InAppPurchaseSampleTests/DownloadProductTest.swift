//
//  DownloadProductTest.swift
//  InAppPurchaseSampleTests
//
//  Created by uematsushun on 2020/09/25.
//

import XCTest
import StoreKitTest

@testable import InAppPurchaseSample

class DownloadProductTest: XCTestCase, DownloadedProductNotification {
	
	private let downloadProduct = DownloadProduct.shared
	private var getProductExp: XCTestExpectation!
	private var session: SKTestSession!
	
	// Store Result
	private var productIds: [String]!
	private var downloadError: DownloadProductError?
	
	override func setUpWithError() throws {
		getProductExp = XCTestExpectation(description: "Download product item")
		
		session = try SKTestSession(configurationFileNamed: "Configuration")
		session.disableDialogs = true
		session.clearTransactions()
		
		downloadProduct.delegate = self
	}

	func testIfThereNoUnexpectedSubscriptionProduct_Success() {
		session = try! SKTestSession(configurationFileNamed: "Subscription")
		session.disableDialogs = true
		session.clearTransactions()
		
		downloadProduct(productIds: ["all.drinking"])
		
		wait(for: [getProductExp], timeout: 5.0)
		
		if let downloadError = self.downloadError {
			XCTFail(downloadError.message)
		} else {
			XCTAssertEqual(productIds.first, "all.drinking")
		}
	}
	
	func testIfThereNoUnexpectedProducts_Success() {
		let ids: [String] = ["berry-blue", "carrot-chops", "crazy-colada", "hulking-lemonade",
							 "kiwi-cutie", "lemonberry", "love-you-berry-much", "mango-jambo",
							 "one-in-a-melon", "papas-papaya", "peanut-butter-cup", "sailor-man",
							 "thats-a-smore", "thats-berry-bananas", "tropical-blue"]
		
		let url = Bundle.main.url(forResource: "Configuration", withExtension: "storekit")!
		session = try! SKTestSession(contentsOf: url)
		session.disableDialogs = true
		session.clearTransactions()
		
		downloadProduct(productIds: ids)
		wait(for: [getProductExp], timeout: 5.0)
		
		if let downloadError = self.downloadError {
			XCTFail(downloadError.message)
		} else {
			verifyProduct()
			XCTAssertTrue(self.productIds.isEmpty, "There are no unexpected products.")
		}
	}
	
	func testIfThereIsUnexpectedProducts_Failure() {
		let url = Bundle.main.url(forResource: "Configuration", withExtension: "storekit")!
		session = try! SKTestSession(contentsOf: url)
		session.disableDialogs = true
		session.clearTransactions()
		
		let ids: [String] = ["berry-blue", "carrot-chops", "crazy-colada", "hulking-lemonade",
							 "kiwi-cutie", "dummy", "love-you-berry-much", "mango-jambo",
							 "one-in-a-melon", "papas-papaya", "peanut-butter-cup", "sailor-man",
							 "thats-a-smore", "thats-berry-bananas", "tropical-blue"]
		
		downloadProduct(productIds: ids)
		wait(for: [getProductExp], timeout: 5.0)
		
		if let downloadError = self.downloadError {
			switch downloadError {
				case .invalidProduct:
					XCTAssertEqual(downloadError, DownloadProductError.invalidProduct, "dummy is must invalid")
				default:
					XCTFail("dummy is must invalid")
			}
		} else {
			XCTFail("dummy is must invalid")
		}
	}
	
	// Verify if there are any unexpected products.
	// If there are no unexpected products, the array is empty.
	private func verifyProduct() {
		Smoothie.allIDs.forEach { id in
			productIds.removeAll(where: { id == $0 } )
		}
	}
	
	// MARK: - DownloadedProductNotification
	
	func downloaded(products: [SKProduct]?, error: Error?) {
		if let error = error, let downloadError = error as? DownloadProductError {
			self.downloadError = downloadError
		} else {
			productIds = products?.map { $0.productIdentifier }
		}
		getProductExp.fulfill()
	}
}
