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
    
    init(_ data: [String: AnyObject]) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.image = data["image"] as! String
    }
}
