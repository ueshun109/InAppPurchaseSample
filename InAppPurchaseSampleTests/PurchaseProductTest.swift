//
//  PurchaseProductTest.swift
//  InAppPurchaseSampleTests
//
//  Created by uematsushun on 2020/09/26.
//

import Foundation
import XCTest
import StoreKitTest

@testable import InAppPurchaseSample

class PurchaseProductTest: XCTestCase, DownloadedProductNotification, PurchasedResultNotification {
	private let purchase = PurchaseProduct.shared
	private let download = DownloadProduct.shared
	
	private var getProductExp: XCTestExpectation!
	private var buyProductExp: XCTestExpectation!
	private var product: SKProduct!
	private var session: SKTestSession!
	private var transaction: SKPaymentTransaction!
	
	override func setUp() {
		getProductExp = XCTestExpectation(description: "Download product item")
		buyProductExp = XCTestExpectation(description: "Purchase product item")

		download.delegate = self
		purchase.delegate = self
		SKPaymentQueue.default().add(purchase)
		
		let url = Bundle.main.url(forResource: "Configuration", withExtension: "storekit")!
		session = try! SKTestSession(contentsOf: url)
		session.disableDialogs = true
		session.clearTransactions()
	}
	
	func testPurchaseBerryBlue_Success() {
		download(productIds: Smoothie.allIDs)
		wait(for: [getProductExp], timeout: 5.0)

		purchase(product: product)
		wait(for: [buyProductExp], timeout: 5.0)
		
		XCTAssertTrue(isSuccess(transaction: transaction), "expected product id: \(Smoothie.allIDs.first!). But actual is \(transaction.payment.productIdentifier). Or transaction state is purchased.")
	}
	
	func testPurchaseBerryBlue_Failed() {
		// This is that whether transactions fail in the test environment.
		session.failTransactionsEnabled = true
		
		download(productIds: Smoothie.allIDs)
		wait(for: [getProductExp], timeout: 5.0)

		purchase(product: product)
		wait(for: [buyProductExp], timeout: 5.0)
		
		XCTAssertTrue(isFail(transaction: transaction), "transaction state is a failed")
	}
	
	private func isSuccess(transaction: SKPaymentTransaction) -> Bool {
		transaction.payment.productIdentifier == Smoothie.allIDs.first && transaction.transactionState == .purchased
	}
	
	private func isFail(transaction: SKPaymentTransaction) -> Bool {
		transaction.payment.productIdentifier == Smoothie.allIDs.first && transaction.transactionState == .failed
	}
	
	// MARK: - DownloadedProductNotification
	
	func downloaded(products: [SKProduct]?, error: Error?) {
		product = products!.first
		getProductExp.fulfill()
	}
	
	// MARK: - PurchasedResultNotification
	
	func completed(transaction: SKPaymentTransaction) {
		self.transaction = transaction
		buyProductExp.fulfill()
	}
	
	func failed(transaction: SKPaymentTransaction) {
		self.transaction = transaction
		buyProductExp.fulfill()
	}
}
