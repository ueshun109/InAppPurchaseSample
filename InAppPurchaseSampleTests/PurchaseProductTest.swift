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
	}
	
	func testPurchaseSubscription_Success() {
		let url = Bundle.main.url(forResource: "Subscription", withExtension: "storekit")!
		session = try! SKTestSession(contentsOf: url)
		session.disableDialogs = true
		session.clearTransactions()
		
		download(productIds: ["all.drinking"])
		wait(for: [getProductExp], timeout: 5.0)
		
		purchase(product: product)
		wait(for: [buyProductExp], timeout: 5.0)
		
		XCTAssertTrue(isSuccess(transaction: transaction, productId: "all.drinking"), "expected product id: all.drinking. But actual is \(transaction.payment.productIdentifier). Or transaction state is purchased.")
	}
	
	func testPurchaseBerryBlue_Success() {
		let url = Bundle.main.url(forResource: "Configuration", withExtension: "storekit")!
		session = try! SKTestSession(contentsOf: url)
		session.disableDialogs = true
		session.clearTransactions()
		
		download(productIds: Smoothie.allIDs)
		wait(for: [getProductExp], timeout: 5.0)

		purchase(product: product)
		wait(for: [buyProductExp], timeout: 5.0)
		
		XCTAssertTrue(isSuccess(transaction: transaction, productId: Smoothie.allIDs.first!), "expected product id: \(Smoothie.allIDs.first!). But actual is \(transaction.payment.productIdentifier). Or transaction state is purchased.")
	}
	
	func testPurchaseBerryBlue_Failed() {
		let url = Bundle.main.url(forResource: "Configuration", withExtension: "storekit")!
		session = try! SKTestSession(contentsOf: url)
		session.disableDialogs = true
		session.clearTransactions()
		
		// This is that whether transactions fail in the test environment.
		session.failTransactionsEnabled = true
		
		download(productIds: Smoothie.allIDs)
		wait(for: [getProductExp], timeout: 5.0)

		purchase(product: product)
		wait(for: [buyProductExp], timeout: 5.0)
		
		XCTAssertTrue(isFail(transaction: transaction, productId: Smoothie.allIDs.first!), "transaction state is a failed")
	}
	
	override func tearDown() {
		session = nil
	}
	
	private func isSuccess(transaction: SKPaymentTransaction, productId: String) -> Bool {
		transaction.payment.productIdentifier == productId && transaction.transactionState == .purchased
	}
	
	private func isFail(transaction: SKPaymentTransaction, productId: String) -> Bool {
		transaction.payment.productIdentifier == productId && transaction.transactionState == .failed
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
