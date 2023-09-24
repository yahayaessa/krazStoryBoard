//
//  PKIAPHandler.swift
//  krazStoryBoard
//
//  Created by Yahaya on 20/09/2023.
//

import Foundation
import StoreKit

typealias RequestProductsResult = Result<[SKProduct], Error>
typealias PurchaseProductResult = Result<Bool, Error>

typealias RequestProductsCompletion = (RequestProductsResult) -> Void
typealias PurchaseProductCompletion = (PurchaseProductResult) -> Void

class Purchases: NSObject {
    static let `default` = Purchases()

    private let productIdentifiers = Set(
       arrayLiteral: "RemoveAdMonth"
    )

    private var products: [String: SKProduct]?
    private var productRequest: SKProductsRequest?

    func initialize(completion: @escaping RequestProductsCompletion) {
        requestProducts(completion: completion)
    }

    private var productsRequestCallbacks = [RequestProductsCompletion]()

    private func requestProducts(completion: @escaping RequestProductsCompletion) {
        guard productsRequestCallbacks.isEmpty else {
            productsRequestCallbacks.append(completion)
            return
        }

        productsRequestCallbacks.append(completion)

        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()

        self.productRequest = productRequest
    }
    fileprivate var productPurchaseCallback: ((PurchaseProductResult) -> Void)?
    func purchaseProduct(productId: String, completion: @escaping (PurchaseProductResult) -> Void) {
        // 1:
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }

        // 2:
        guard let product = products?[productId] else {
            completion(.failure(PurchasesError.productNotFound))
            return
        }

        productPurchaseCallback = completion
        // 3:
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func restorePurchases(completion: @escaping (PurchaseProductResult) -> Void) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }

        productPurchaseCallback = completion
        // 4:
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
extension Purchases: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest,
                        didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            print("Found 0 products")

            productsRequestCallbacks.forEach { $0(.success(response.products)) }
            productsRequestCallbacks.removeAll()
            return
        }

        var products = [String: SKProduct]()
        for skProduct in response.products {
            print("Found product: \(skProduct.productIdentifier)")
            products[skProduct.productIdentifier] = skProduct
        }

        self.products = products

        productsRequestCallbacks.forEach { $0(.success(response.products)) }
        productsRequestCallbacks.removeAll()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products with error:\n \(error)")

        productsRequestCallbacks.forEach { $0(.failure(error)) }
        productsRequestCallbacks.removeAll()
    }
}

extension Purchases: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // 1:
        for transaction in transactions {
            switch transaction.transactionState {
            // 2:
            case .purchased, .restored:
                if finishTransaction(transaction) {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    productPurchaseCallback?(.success(true))
                } else {
                    productPurchaseCallback?(.failure(PurchasesError.unknown))
                }
            // 3:
            case .failed:
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
        
        productPurchaseCallback = nil
   }
}

extension Purchases {
    // 4:
    func finishTransaction(_ transaction: SKPaymentTransaction) -> Bool {
        let productId = transaction.payment.productIdentifier
        print("Product \(productId) successfully purchased")
        return true
    }
}
enum PurchasesError: Error {
    case purchaseInProgress
    case productNotFound
    case unknown
}
