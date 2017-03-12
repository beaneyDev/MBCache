//
//  ViewController.swift
//  MBCache
//
//  Created by beaney1232 on 03/12/2017.
//  Copyright (c) 2017 beaney1232. All rights reserved.
//

import UIKit
import MBCache
import MBUtils

class ViewController: UIViewController {

    @IBOutlet weak var imageView: MBImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MBOn.delay(0.1) { 
            self.imageView.layer.borderColor = UIColor.lightGray.cgColor
            self.imageView.layer.borderWidth = 0.5
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0
            self.imageView.configureWithURL(url: "http://the-media-image.com/wp-content/uploads/2016/02/google-logo.jpg", with: .pop, defaultImage: nil)
            self.imageView.MBContentMode = UIViewContentMode.scaleAspectFill
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

