//
//  ViewController.swift
//  Barbell Plate Calculator
//
//  Created by Robert Oneill on 08/04/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    let plates : [Float] = [25, 20, 15, 10, 5, 2.5, 1.25]
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var platesNeeded: UILabel!
    
    @IBAction func calculatePlates(_ sender: Any) {
        
        
        
        for plate in plates {
            
            print(plate)
            
        }
        
        plateCalculation()
        
        
    }
    
    func plateCalculation () {

        var i : Float = 35
        
        if i / plates[0] != 0 {
            
            i = i - plates[0]
            
            print(i)
            
            platesNeeded.text = String(i)

        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

