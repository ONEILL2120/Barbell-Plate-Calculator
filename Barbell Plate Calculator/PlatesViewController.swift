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

enum Plate: Float {
    case twentyFiveKg = 25
    case twentyKg = 20
    case fifteenKg = 15
    case tenKg = 10
    case fiveKg = 5
    case twoAndAHalfKg = 2.5
    case oneAndAQuarterKg = 1.25
    
    static let allCases = [twentyFiveKg, twentyKg, fifteenKg, tenKg, fiveKg, twoAndAHalfKg, oneAndAQuarterKg]
    
    var kg : Float {
        
        return self.rawValue
    }
}

struct PlateAssignment {
    
   
        
    
    
    //write test, does it need to be a function?
    //research structs,enums etc.
}



class ViewController: UIViewController {
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    private var groupedPlates = [Plate: [Plate]]()
    
    @IBAction func calculatePlates(_ sender: Any) {
        
        let calc = PlateCalculator()
        
        guard let weightText = weightTextField.text, let weight = Float(weightText) else {
            
            return
        }
        
        groupedPlates = self.calcGroupedPlates(plates: calc.calculate(weightInKg: weight))
        
        
        
        
        
        
      
        
    }
    
    private func calcGroupedPlates (plates: [Plate]) -> [Plate:[Plate]] {
        
        var result = [Plate:[Plate]]()
        
        for plate in plates {
            
            if var plates = result[plate] {
                
                plates.append(plate)
                result[plate] = plates
                
            } else {
                
                var plates = [Plate]()
                plates.append(plate)
                result[plate] = plates
                
            }
            
        }
        
        return result
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

extension ViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Plate.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            
        }
        
        
        return cell!
    }
    
}



