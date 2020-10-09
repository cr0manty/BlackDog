//
//  ProductListViewCell.swift
//  AppClip
//
//  Created by Просто Денис on 09.10.2020.
//

import UIKit

class ProductListViewCell: UICollectionViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func loadCell(_ product: Product) {
        self.image.layer.cornerRadius = 10
        self.title.text = product.name
        self.price.text = product.priceWithCurrency
        self.image.downloadImageFrom(product.image)
    }
}
