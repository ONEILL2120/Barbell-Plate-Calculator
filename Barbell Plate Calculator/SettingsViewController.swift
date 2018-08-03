//
//  SettingsViewController.swift
//  Barbell Plate Calculator
//
//  Created by Robert Oneill on 25/06/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import UIKit

protocol WeightTableViewCellDelegate: class {
    func weightTableViewCell(_ cell: WeightTableViewCell, numberOfPlatesDidChange newValue: Int)
    
}



class WeightTableViewCell: UITableViewCell {
    
    weak var delegate: WeightTableViewCellDelegate?
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var numberOfPlates: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        let newValue = Int(sender.value)
        numberOfPlates.text = newValue.description
        delegate?.weightTableViewCell(self, numberOfPlatesDidChange: newValue)
        
    }
}

protocol SettingsViewControllerDelegate: class {
    func SettingsViewController(_ viewController: SettingsViewController, isDoneWithPlateCount plateCount: [Plate:Int], barbellWeightSelected: Float)
    
}

class Settings: Codable {
    var barbellWeight: Float
    var plateCount: [Plate:Int]
    
    init(barbellWeight: Float, plateCount: [Plate:Int]) {
        self.barbellWeight = barbellWeight
        self.plateCount = plateCount
    }
}

class SettingsPersistence {
    
    private let url: URL
    private let fileManager = FileManager()
    
    init() {
    
    let documentDirectoryURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    self.url = documentDirectoryURL.appendingPathComponent("settings.json")
        
    }
    
    func save(plateCount: [Plate:Int], barbellWeight: Float) throws {
        let settings = Settings(barbellWeight: barbellWeight, plateCount: plateCount)
        try save(settings: settings)
        
    }
    
    private func save(settings: Settings) throws {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(settings)
        try! data.write(to: url)
    }
    
    func load() throws -> Settings {
        if !fileManager.fileExists(atPath: url.path){
         let defaultSettings = Settings(barbellWeight: 20, plateCount: [
            .twentyKg : 20,
            .tenKg : 10
            ])
            
            try save(settings: defaultSettings)
            return defaultSettings
            
        }
        
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: url)
        let settings = try! decoder.decode(Settings.self, from: data)
        return settings
    }
}

class SettingsViewController: UIViewController, PresentsAlert {
    
    @IBOutlet weak var barbellSwitch: UISwitch!

    weak var delegate: SettingsViewControllerDelegate?
    var plates = Plate.allCases
    var platesCount = [Plate:Int]()
    var barbellWeight: Float = 20
    private let persistence = SettingsPersistence()
    
    
    @IBOutlet weak var setupTableView: UITableView!
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        do {
            try persistence.save(plateCount: platesCount, barbellWeight: barbellWeight)
            
        } catch {
            
            showErrorAlert(error: error)
        }
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
        
        }
    
    @objc func switchIsChanged(barbellSwitch: UISwitch){
        if barbellSwitch.isOn {
            barbellWeight = 20
        } else {
            barbellWeight = 15
        }
        
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barbellSwitch.addTarget(self, action: #selector(SettingsViewController.switchIsChanged(barbellSwitch:)), for: .valueChanged)
    }

}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! WeightTableViewCell
        
        
        let allPlates = plates[indexPath.row]
        cell.weightLabel.text = "\(allPlates.kg) KG"
        cell.delegate = self
        
        return cell
    }
}

extension SettingsViewController: WeightTableViewCellDelegate {
    func weightTableViewCell(_ cell: WeightTableViewCell, numberOfPlatesDidChange newValue: Int) {
        guard let indexPath = setupTableView.indexPath(for: cell) else {
            return
        }
        
        let plate = plates[indexPath.row]
        platesCount[plate] = newValue
        
    }
}
