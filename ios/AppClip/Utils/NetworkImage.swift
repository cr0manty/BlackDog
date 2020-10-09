//
//  NetworkImage.swift
//  AppClip
//
//  Created by Просто Денис on 09.10.2020.
//

import UIKit

class ImageViewLoader: UIImageView {
    let imageCache = NSCache<NSString, AnyObject>()
    var imageURLString: String?
    
    var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }
    
    public func downloadImageFrom(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            
            let session = URLSession(configuration: .default)
            let activityIndicator = self.activityIndicator
            
            DispatchQueue.main.async {
                activityIndicator.startAnimating()
            }
            
            let downloadImageTask = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let imageData = data {
                        DispatchQueue.main.async {[weak self] in
                            var imageToCache = UIImage(data: imageData)
                            self?.image = nil
                            self?.image = imageToCache
                            self?.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                            imageToCache = nil
                        }
                    }
                }
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
                session.finishTasksAndInvalidate()
            }
            downloadImageTask.resume()
        }
    }
    
    
}

