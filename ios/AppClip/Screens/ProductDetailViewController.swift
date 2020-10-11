//
//  ProductDetailViewController.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var product: Product!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var variantsCollectionview: UICollectionView!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.product.name
        self.image.downloadImageFrom(self.product.image)
        self.image.layer.cornerRadius = 10
        self.descriptionView.text = self.product.itemDescription
        self.descriptionView.isEditable = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
