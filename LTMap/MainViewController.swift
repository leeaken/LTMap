//
//  MainViewController.swift
//  LTMap
//
//  Created by aken on 2017/5/27.
//  Copyright © 2017年 LTMap. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func simpleClick(_ sender: Any) {
        
        let vc = ViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func locationClick(_ sender: Any) {
        
        let vc = LTLocationVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

}
