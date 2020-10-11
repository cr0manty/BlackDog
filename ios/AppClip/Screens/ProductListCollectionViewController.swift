//
//  ProductListCollectionViewController.swift
//  AppClip
//
//  Created by Просто Денис on 07.10.2020.
//

import UIKit

private let reuseIdentifier = "ItemCollectionsCell"

class ProductListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.category.name
        self.getProductList()
    }

    func getProductList() {
        RequestManager.makeRequest(url: "/menu/categories-list/\(self.category.id)") { (response) in
            var productList: [Product] = []

            for data in response["products"] as! [AnyObject] {
                let product: Product = Product(data as! [String: AnyObject])
                productList.append(product)
            }
            self.category.renewProducts(products: productList)
            self.collectionView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category.productsCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductListViewCell
        
        cell.loadCell(self.category.getProductAt(indexPath.row))
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60) / 2, height: self.view.frame.height * 0.3)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailView" {
            let cell = sender as! ProductListViewCell
            let indexPath: NSIndexPath = self.collectionView.indexPath(for: cell)! as NSIndexPath
            let productDetail = segue.destination as! ProductDetailViewController
            
            productDetail.product = self.category.getProductAt(indexPath.row) as Product
        }
    }

}
