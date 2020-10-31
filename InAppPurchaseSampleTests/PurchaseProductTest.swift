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
	private var purchaseProductExp: XCTestExpectation!
	private var product: SKProduct!
	private var session: SKTestSession!
	private var transaction: SKPaymentTransaction!
	
	override func setUpWithError() throws {
		getProductExp = XCTestExpectation(description: "Download product item")
		purchaseProductExp = XCTestExpectation(description: "Purchase product item")
		
		session = try SKTestSession(configurationFileNamed: "Configuration")
		session.disableDialogs = true
		session.clearTransactions()
		session.failTransactionsEnabled = false
		session.interruptedPurchasesEnabled = false

		download.delegate = self
		purchase.delegate = self
		
		download(productIds: Smoothie.allIDs)
		wait(for: [getProductExp], timeout: 0.1)
	}
	
	func testPurchaseBerryBlue_Success() {
		guard let product = product else {
			XCTFail("Must fetch product")
			return
		}
		
		purchase(product: product)
		wait(for: [purchaseProductExp], timeout: 3.0)
		
		XCTAssertTrue(isSuccess(transaction: transaction, productId: Smoothie.allIDs.first!), "expected product id: \(Smoothie.allIDs.first!). But actual is \(transaction.payment.productIdentifier). Or transaction state is purchased.")
		
		SKPaymentQueue.default().finishTransaction(transaction)
	}
	
	func testPurchaseBerryBlue_successAfterInterrupted() {
		guard let product = product else {
			XCTFail("Must fetch product")
			return
		}
		// This is that whether transactions fail in the test environment.
		session.interruptedPurchasesEnabled = true
		
		purchase(product: product)
		wait(for: [purchaseProductExp], timeout: 3.0)
		
		session.allTransactions().forEach { transaction in
			do {
				try session.resolveIssueForTransaction(identifier: transaction.identifier)
			} catch {
				XCTFail()
			}
		}
		
		purchaseProductExp = XCTestExpectation(description: "Purchase product item")
		wait(for: [purchaseProductExp], timeout: 3.0)
		
		XCTAssertTrue(isSuccess(transaction: transaction, productId: Smoothie.allIDs.first!), "\(transaction.transactionState.rawValue) is not purchased")
		SKPaymentQueue.default().finishTransaction(transaction!)
	}
	
	func testPurchaseBerryBlue_failed() {
		guard let product = product else {
			XCTFail("Must fetch product")
			return
		}
		
		session.failTransactionsEnabled = true
		purchase(product: product)
		
		wait(for: [purchaseProductExp], timeout: 3.0)
		XCTAssertTrue(isFail(transaction: transaction, productId: Smoothie.allIDs.first!), "\(transaction.transactionState.rawValue) is not failed")
		SKPaymentQueue.default().finishTransaction(transaction!)
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
		purchaseProductExp.fulfill()
	}
	
	func failed(transaction: SKPaymentTransaction) {
		self.transaction = transaction
		purchaseProductExp.fulfill()
	}
}
