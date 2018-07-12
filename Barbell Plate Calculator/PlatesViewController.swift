//
//  ViewController.swift
//  Barbell Plate Calculator
//
//  Created by Robert Oneill on 08/04/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import UIKit

class PlateCalculator {
    
    private let plates : [Plate] = Plate.allCases
    
    
    public func calculate(weightInKg weight: Float) -> [Plate] {
        
        let barWeight: Float = 20
        
        var weightToAddToBar = weight - barWeight
        
        var result = [Plate]()
        
        for index in plates.indices {
            
            let plate = plates[index]
            
            while weightToAddToBar / plate.kg >= 2 {
                
                weightToAddToBar -= (plate.kg * 2)
                
                result.append(plate)
                result.append(plate)
            
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





class ViewController: UIViewController {
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let allPlates = Plate.allCases
    
    private var groupedPlates = [Plate: [Plate]]()
    
    @IBAction func calculatePlates(_ sender: Any) {
        
        let calc = PlateCalculator()
        
        guard let weightText = weightTextField.text, let weight = Float(weightText) else {
            
            return
        }
        
        let plates = calc.calculate(weightInKg: weight)
        groupedPlates = self.calcGroupedPlates(plates: plates)
        
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet.init(integer:0), with: .automatic)
        tableView.endUpdates()
        
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
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlates.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            
        }
      
        
        let plate = allPlates[indexPath.row]
        
        cell?.textLabel?.text = "\(plate.kg) KG"
        
        
        if let plates = groupedPlates[plate] {
            cell?.detailTextLabel?.text = "\(plates.count)"
            cell?.textLabel?.textColor = UIColor.black
            
        } else {
            cell?.detailTextLabel?.text = nil
            
        }
        
        return cell!
    }
}



