//
//  ViewController.swift
//  GetPeached
//
//  Created by Ananth Suresh on 10/7/16.
//  Copyright © 2016 Fkboinc. All rights reserved.
//

import UIKit
var finalName = ""
var finalNumber = ""
var finalSex = ""

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let savedName = UserDefaults.standard
        if let name = savedName.string(forKey: "Name"){
            finalName = name
        }
        let savedNumber = UserDefaults.standard
        if let number = savedNumber.string(forKey: "Number"){
            finalNumber = number
        }
        let savedSex = UserDefaults.standard
        let storedSex = savedSex.integer(forKey: "SexChosen")
        if storedSex == 0{
            finalSex = "Male"
        }
        if storedSex == 1{
            finalSex = "Female"
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

