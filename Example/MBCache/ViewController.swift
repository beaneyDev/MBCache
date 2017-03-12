//
//  ViewController.swift
//  MBCache
//
//  Created by beaney1232 on 03/12/2017.
//  Copyright (c) 2017 beaney1232. All rights reserved.
//

import UIKit
import MBCache

class ViewController: UIViewController {

    @IBOutlet weak var imageView: MBImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.configureWithURL(url: "http://the-media-image.com/wp-content/uploads/2016/02/google-logo.jpg", with: .pop)
        imageView.MBContentMode = UIViewContentMode.scaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

