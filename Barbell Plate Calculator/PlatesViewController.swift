//
//  ViewController.swift
//  Barbell Plate Calculator
//
//  Created by Robert Oneill on 08/04/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import UIKit

enum PlateCalculatorError {
    case noAvailablePlates
    case notEnoughPlates(_: Float)
}

extension PlateCalculatorError: LocalizedError {
    var errorDescription: String? {
    switch self {
    case .noAvailablePlates:
        return "No available plates, Please add plates using setup page."
    case .notEnoughPlates(let missingAmount):
        return "Not enough plates available, you need \(missingAmount)Kg."
        }
    }
}


class PlateCalculator {
    
    
    private let plates : [Plate] = Plate.allCases
    
    public func calculate(weightInKg weight: Float, settings: Settings) throws -> [Plate] {
        
        if settings.plateCount.isEmpty {
           throw PlateCalculatorError.noAvailablePlates
        }
        
        let barWeight: Float = settings.barbellWeight
        
        var weightToAddToBar = weight - barWeight
        
        var result = [Plate]()
        
        let sortedPlates = settings.plateCount.keys.sorted { (a, b) -> Bool in
            a.rawValue > b.rawValue
        }
        
        for plate in sortedPlates {
            guard var amountAvailable = settings.plateCount[plate] else {
                
                continue
            }
                
                while weightToAddToBar / plate.kg >= 2 && amountAvailable > 0 {
                    
                    if amountAvailable > 0 {
                        result.append(plate)
                        amountAvailable = amountAvailable - 1
                        weightToAddToBar -= plate.kg
                    }
                    
                    if amountAvailable > 0 {
                        result.append(plate)
                        amountAvailable = amountAvailable - 1
                        weightToAddToBar -= plate.kg
                    }
                }
        
        }
        
        let amountOnBar = result.reduce(barWeight) { (result, plate) -> Float in
            result + plate.rawValue
        }
        if amountOnBar != weight {
            let missingAmount = weight - amountOnBar
            throw PlateCalculatorError.notEnoughPlates(missingAmount)
        }
        
        return result
    }
}

enum Plate: Float, Codable {
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
    @IBOutlet weak var enterWeightLabel: UILabel!
    
    private var settings: Settings!
    private let settingsPersistence = SettingsPersistence()
    
    let allPlates = Plate.allCases
    
    private var groupedPlates = [Plate: [Plate]]()
    
    @IBAction func calculatePlates(_ sender: Any) {
        
        let calc = PlateCalculator()
        
        if (weightTextField.text?.isEmpty)! {
            createAlert(title: "Try Again", message: "Please enter a weight.")
        }
        
        do {
            
            guard let weightText = weightTextField.text, let weight = Float(weightText) else {
                
                return
            }
            
            let plates = try calc.calculate(weightInKg: weight, settings: settings)
            groupedPlates = self.calcGroupedPlates(plates: plates)
            } catch {
            showErrorAlert(error: error)
            }
        
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet.init(integer:0), with: .automatic)
            tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.mainColour
        tableView.backgroundColor = theme.mainColour
        enterWeightLabel.textColor = theme.tintColour
        tableView.reloadData()
        
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
        
        do{
            settings = try settingsPersistence.load()
        } catch {
            showErrorAlert(error: error)
        }
        
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
    func SettingsViewController(_ viewController: SettingsViewController, isDoneWithSettings settings: Settings) {
        self.settings = settings
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
      
        let theme = ThemeManager.currentTheme()
        let plate = allPlates[indexPath.row]
        
        cell?.textLabel?.text = "\(plate.kg) KG"
        cell?.textLabel?.textColor = theme.tintColour
        cell?.backgroundColor = theme.mainColour
        
        
        
        if let plates = groupedPlates[plate] {
            cell?.detailTextLabel?.text = "\(plates.count)"
            cell?.textLabel?.textColor = theme.tintColour
            cell?.backgroundColor = theme.tintColour
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


