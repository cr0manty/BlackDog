//
//  CategoryViewController.swift
//  AppClip
//
//  Created by Просто Денис on 06.10.2020.
//

import UIKit

private let reuseIdentifier = "ItemCollectionsCell"


class CategoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategories()
    }
    
    func getCategories(limit: Int = 10, offset: Int = 0) {
        RequestManager.makeRequest(url: "/menu/categories-list") { (response) in
            for data in response["results"] as! [AnyObject] {
                let category: Category = Category(data as! [String: AnyObject])
                self.categories.append(category)
            }
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
        return self.categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryListViewCell
        
        cell.loadCell(self.categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60) / 2, height: self.view.frame.height * 0.3)
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductList" {
            let cell = sender as! CategoryListViewCell
            let indexPath: NSIndexPath = self.collectionView.indexPath(for: cell)! as NSIndexPath
            let productList = segue.destination as! ProductListCollectionViewController
            
            productList.category = self.categories[indexPath.row] as Category
        }
    }
}
