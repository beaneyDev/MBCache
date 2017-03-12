//
//  MBImageView.swift
//  Pods
//
//  Created by Matt Beaney on 12/03/2017.
//
//

import Foundation
import UIKit
import MBUtils

public enum MBImageAnimationType {
    case fade
    case pop
    case none
}

open class MBImageView: UIView {
    var imageView: UIImageView!
    open var MBContentMode: UIViewContentMode? {
        didSet {
            if let imageView = imageView {
                imageView.contentMode = self.MBContentMode ?? UIViewContentMode.scaleAspectFit
            }
        }
    }
    
    func configureImageView(defaultImage: UIImage? = nil) {
        if imageView != nil {
            return
        }
        
        self.imageView = UIImageView()
        self.imageView.image = defaultImage
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[image]|", options: [], metrics: nil, views: ["image": self.imageView])
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[image]|", options: [], metrics: nil, views: ["image": self.imageView])
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }
    
    open func configureWithURL(url: String, with animation: MBImageAnimationType, defaultImage: UIImage? = nil) {
        configureImageView(defaultImage: defaultImage)
        
        guard let url: URL = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        //Check to see if there's a cache.
        if let cachedImage = MBCacheController.shared.cachedResourceForRequest(request), let image = UIImage(data: cachedImage) {
            configureWithImage(image: image, animation: animation)
            return
        }
        
        //No cached image found, try downloading it.
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                self.configureWithImage(image: defaultImage, animation: animation)
                return
            }
            
            //Download successful, cache the data and apply the image.
            MBCacheController.shared.writeCacheResourceToPersistentCache(data, request: request)
            self.configureWithImage(image: image, animation: animation)
        }
        dataTask.resume()
    }
    
    open func configureWithImage(image: UIImage?, animation: MBImageAnimationType) {
        MBOn.main {
            self.imageView.alpha = 0.0
            self.imageView.image = image
            
            switch animation {
            case .none :
                self.imageView.alpha = 1.0
                break
            case .fade :
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.alpha = 1.0
                })
                break
            case .pop :
                self.imageView.alpha = 1.0
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.imageView.transform = CGAffineTransform.identity
                    })
                })
                break
            default:
                self.imageView.alpha = 1.0
                break
            }
        }
    }
}
