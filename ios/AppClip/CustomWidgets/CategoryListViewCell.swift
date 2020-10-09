//
//  CollectionViewCell.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import UIKit



class CategoryListViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func loadCell(_ category: Category) {
        self.image.layer.cornerRadius = 10
        self.title.text = category.name
        self.image.downloadImageFrom(category.image)
    }
}
