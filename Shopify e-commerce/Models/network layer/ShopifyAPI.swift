//
//  ShopifyAPI.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/23/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
class ShopifyAPI : BaseAPI<ApplicationNetworking>{
    
    static let shared = ShopifyAPI()
    
    private override init() {}
    
    // MARK: Ahmed Section
    
    //end
    
    // MARK: Amr Section
    
    
    //end
    
    
    // MARK: Ayman Section
    func getCustomers(completion: @escaping (Result<Customer?,NSError>) -> Void) {
            self.fetchData(target: .customers, responseClass: Customer.self) { (results) in
                
                completion(results)
            }
            
        }
//    func getCustomers(completion: @escaping (Result<Customer?,NSError>) -> Void) {
//        self.fetchData(target: .customers, responseClass: Customer.self) { (results) in
//
//            completion(results)
//        }
//
//    }
    //end
    
    
    // MARK: Marwa Section
    
    //end
    
}

//func getProducts(completion: @escaping (Result<ProductModel?,NSError>) -> Void){
//    self.fetchData(target: .products, responseClass: ProductModel.self) { (result) in
//        completion(result)
//    }
//}
