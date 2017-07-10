//
//  ViewController.swift
//  CyclePictureView
//
//  Created by Panda on 2017/7/6.
//  Copyright © 2017年 MooneyWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CyclePictureViewDelegate {

    @IBOutlet weak var cycleView: CyclePictureView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cycleView.imageNames = ["ad01", "ad02", "ad03", "ad04"]
        cycleView.delegate = self
    }

    // MARK: - CyclePictureViewDelegate
    
    func cyclePictureViewDidSelectAt(index: Int) {
        print("click at \(index)")
    }
}

