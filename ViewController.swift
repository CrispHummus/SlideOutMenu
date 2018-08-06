//
//  ViewController.swift
//  Slide out menu
//
//  Created by Tristan Brankovic on 8/4/18.
//  Copyright © 2018 parab3llum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add target to menu button
        let btn = self.view.viewWithTag(10) as! UIButton
        btn.toggleMenu(btn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

