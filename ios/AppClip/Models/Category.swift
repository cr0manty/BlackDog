//
//  Category.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import Foundation

class Category: NSObject {
    var id: Int
    var name: String
    var image: String
    private var products: [Product] = []

    init(_ data: [String: AnyObject]) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.image = data["image"] as! String
    }
    
    func addProduct(_ product: Product) {
        if !products.contains(where: { (elemtn) in
            return product.id == elemtn.id
        }) {
            self.products.append(product)
        }
    }
    
    func getProductAt(_ index: Int) -> Product {
        return self.products[index]
    }
    
    func removeProductAt(_ index: Int) {
        self.products.remove(at: index)
    }
    
    var productsCount: Int {
        get {
            return self.products.count
        }
    }
    
    func renewProducts(products: [Product]) {
        self.products = products
    }
}
