//
//  ViewController.swift
//  Barbell Plate Calculator
//
//  Created by Robert Oneill on 08/04/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import UIKit

class PlateCalculator {
    
    private let plates : [Float] = [25, 20, 15, 10, 5, 2.5, 1.25]
    
    
    public func calculate(weightInKg weight: Float) -> [Float] {
        
        let barWeight: Float = 20
        
        var weightToAddToBar = weight - barWeight
        
        var result = [Float]()
        
        var plate = 0
        
        for index in plates.indices {
            
            while weightToAddToBar / plates[index] >= 2 {
                
                weightToAddToBar -= (plates[index] * 2)
                
                result.append(plates[index])
                result.append(plates[index])
            
            }
            
            
         
            
        }
        
        return result
        
    }
    
    
}



enum Weights {
    case twentyFiveKg
    case twentyKg
    case fifteenKg
    case tenKg
    case fiveKg
    case twoAndAHalfKg
    case oneAndAQuarterKg
}

struct PlateAssignment {
    
   
        
    
    
    //write test, does it need to be a function?
    //research structs,enums etc.
}



class ViewController: UIViewController {
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var platesNeeded: UILabel!
    
    @IBOutlet weak var twentyFiveKgPlates: UILabel!
    
    @IBOutlet weak var fifteenKgPlates: UILabel!
    
    @IBOutlet weak var tenKgPlates: UILabel!
    
    @IBOutlet weak var fiveKgPlates: UILabel!
    
    @IBOutlet weak var twoAndAHalfKgPlates: UILabel!
    
    @IBOutlet weak var oneAndAQuarterKgPlates: UILabel!
    
    @IBAction func calculatePlates(_ sender: Any) {
        
        let calc = PlateCalculator()
        
        let weight = Float(weightTextField.text ?? "0")
        
        let result = calc.calculate(weightInKg: weight!)
        
       //workout how to assign each number of weights to the correct label.
        
        
        let countedSet = NSCountedSet(array:result)
        
        for value in countedSet.allObjects {
            
            print(countedSet.count(for: 25))
            
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

