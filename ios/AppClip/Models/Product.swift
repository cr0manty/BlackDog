//
//  Product.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import Foundation

class Product: NSObject {
    var id: Int
    var name: String
    var itemDescription: String
    var price: String
    var image: String
    var variations: [ProductVariation]
    
    init(_ data: [String: AnyObject]) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.image = data["image"] as! String
        self.itemDescription = data["description"] as! String
        self.price = data["price"] as! String
        self.variations = ProductVariation.arrayFromJson(data["variations"] as! [AnyObject])
    }
    
    var priceWithCurrency: String {
        get {
            return "\(price) грн"
        }
    }
}
