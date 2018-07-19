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
    
    public func calculate(weightInKg weight: Float, availablePlates: [Plate:Int]) -> [Plate] {
        
        let barWeight: Float = 20
        
        var weightToAddToBar = weight - barWeight
        
        var result = [Plate]()
       
        for (key, value) in availablePlates {
            
            while weightToAddToBar / key.kg >= 2 {
                weightToAddToBar -= (key.kg * 2)
                
                result.append(key)
                result.append(key)
                
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

class ViewController: UIViewController, PresentsAlert {
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var availablePlates = [Plate:Int]()
    
    let allPlates = Plate.allCases
    
    //is this needed?
    private var groupedPlates = [Plate: [Plate]]()
    
    @IBAction func calculatePlates(_ sender: Any) {
        
        let calc = PlateCalculator()
        
        guard let weightText = weightTextField.text, let weight = Float(weightText) else {
            
            return
        }
        
        if availablePlates.isEmpty {
            createAlert(title: "Error", message: "No Plates Available!")
        }
        
        let plates = calc.calculate(weightInKg: weight, availablePlates: availablePlates)
        groupedPlates = self.calcGroupedPlates(plates: plates)
        
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet.init(integer:0), with: .automatic)
        tableView.endUpdates()
        
    }
    
    //edit this to use availblePlates?
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings" {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.delegate = self
        }
    }


}

extension ViewController: SettingsViewControllerDelegate {
   func SettingsViewController(_ viewController: SettingsViewController, isDoneWithPlateCount plateCount: [Plate : Int]) {
        availablePlates = plateCount
        
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

protocol PresentsAlert {
    func createAlert(title: String, message: String)
}

extension PresentsAlert where Self: UIViewController {
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: Error) {
        createAlert(title: "Error", message: error.localizedDescription)
    }
    
}



