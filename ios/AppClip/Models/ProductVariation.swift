//
//  ProductVariation.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import Foundation

class ProductVariation: NSObject {
    var id: Int
    var name: String
    var price: String
    
    init(_ data: [String: AnyObject]) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.price = data["price"] as! String
    }
    
    static func arrayFromJson(_ array: [AnyObject]) -> [ProductVariation] {
        var variations: [ProductVariation] = []
        for data in array {
            variations.append(ProductVariation(data as! [String: AnyObject]))
        }
        return variations
    }
    
    var priceWithCurrency: String {
        get {
            return "\(price) грн"
        }
    }
}
