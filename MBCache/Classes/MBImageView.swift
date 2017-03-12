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

public typealias ImageCompletion = () -> ()

open class MBImageView: UIView {
    //MARK: PROPERTIES
    var imageView: UIImageView! {
        didSet {
            self.clipsToBounds = true
        }
    }
    
    open var MBContentMode: UIViewContentMode? {
        didSet {
            if let imageView = imageView {
                imageView.contentMode = self.MBContentMode ?? UIViewContentMode.scaleAspectFit
            }
        }
    }
    
    //MARK: Initial layout.
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
    
    //MARK: Image assignments
    open func configureWithURL(url: String, with animation: MBImageAnimationType, defaultImage: UIImage? = nil, completion: ImageCompletion? = nil) {
        configureImageView(defaultImage: defaultImage)
        
        guard let url: URL = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        //Check to see if there's a cache.
        if let cachedImage = MBCacheController.shared.cachedResourceForRequest(request), let image = UIImage(data: cachedImage) {
            configureWithImage(image: image, animation: animation, completion: completion)
            return
        }
        
        //No cached image found, try downloading it.
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                self.configureWithImage(image: defaultImage, animation: animation, completion: completion)
                return
            }
            
            //Download successful, cache the data and apply the image.
            MBCacheController.shared.writeCacheResourceToPersistentCache(data, request: request)
            self.configureWithImage(image: image, animation: animation, completion: completion)
        }
        dataTask.resume()
    }
    
    open func configureWithImage(image: UIImage?, animation: MBImageAnimationType, completion: ImageCompletion? = nil) {
        MBOn.main {
            self.alpha = 0.0
            self.imageView.image = image
            
            switch animation {
            case .none :
                self.alpha = 1.0
                break
            case .fade :
                self.fadeAnimation(completion: completion)
                break
            case .pop :
                self.popAnimation(completion: completion)
                break
            default:
                self.imageView.alpha = 1.0
                break
            }
        }
    }
    
    //MARK: Image animations
    func fadeAnimation(completion: ImageCompletion? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }, completion: { (finished) in
            completion?()
        })
    }
    
    func popAnimation(completion: ImageCompletion? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                completion?()
            })
        })
    }
}
