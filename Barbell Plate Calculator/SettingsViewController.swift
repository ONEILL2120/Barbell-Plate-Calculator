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
    
    public func configure(plate: Plate, settings: Settings){
        
        let count = settings.plateCount[plate] ?? 0
        
        
        weightLabel.text = "\(plate.kg) KG"
        numberOfPlates.text = "\(count)"
        stepper.value = Double(count)
        
    }
    
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
    func SettingsViewController(_ viewController: SettingsViewController, isDoneWithSettings settings: Settings)
    
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
    
    public func save(settings: Settings) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(settings)
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
        let data = try Data(contentsOf: url)
        let settings = try decoder.decode(Settings.self, from: data)
        return settings
    }
}

class SettingsViewController: UIViewController, PresentsAlert {
    
    @IBOutlet weak var barbellSwitch: UISwitch!

    weak var delegate: SettingsViewControllerDelegate?
    
    var plates = Plate.allCases
    private let persistence = SettingsPersistence()
    private var settings: Settings!
    
    
    @IBOutlet weak var setupTableView: UITableView!
    
    @IBOutlet var settingsLabels: [UILabel]!
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        do {
            try persistence.save(settings:settings)
            delegate?.SettingsViewController(self, isDoneWithSettings: settings)
            
        } catch {
            showErrorAlert(error: error)
        }
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
        
        }
    
    @objc func switchIsChanged(barbellSwitch: UISwitch){
        if barbellSwitch.isOn {
            settings.barbellWeight = 20
        } else {
            settings.barbellWeight = 15
        }
        
    }
    
    @IBAction func changeTheme(_ sender: Any) {
     let theme = ThemeManager.currentTheme()
        
        var nextThemeRawValue = theme.rawValue + 1
        if nextThemeRawValue > 2 {
            nextThemeRawValue = 0
        }
        
        let nextTheme = Theme.init(rawValue: nextThemeRawValue)!
        
        ThemeManager.applyTheme(nextTheme)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyCurrentTheme()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyCurrentTheme), name: NSNotification.Name(rawValue: "ThemeUpdated"), object: nil)

        // Do any additional setup after loading the view.
        barbellSwitch.addTarget(self, action: #selector(SettingsViewController.switchIsChanged(barbellSwitch:)), for: .valueChanged)
        
        do {
            
            settings = try persistence.load()
            barbellSwitch.isOn = settings.barbellWeight == 20
        } catch {
            showErrorAlert(error: error)
        }
        
        applyCurrentTheme()
        
    }
    
    @objc private func applyCurrentTheme() {
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.mainColour
        setupTableView.backgroundColor = theme.mainColour
        barbellSwitch.tintColor = theme.tintColour
        barbellSwitch.onTintColor = theme.tintColour
        
        if let navigationBar = navigationController?.navigationBar {
        
            navigationBar.barTintColor = theme.mainColour
            navigationBar.tintColor = theme.tintColour
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: theme.tintColour]

        }
        
        for label in settingsLabels {
            label.textColor = theme.tintColour
        }
        
        setupTableView.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! WeightTableViewCell
        
        let plate = plates[indexPath.row]
        cell.configure(plate: plate, settings: settings)
        cell.delegate = self
        
        let theme = ThemeManager.currentTheme()
        cell.backgroundColor = theme.mainColour
        cell.weightLabel.textColor = theme.tintColour
        cell.textLabel?.textColor = theme.tintColour
        cell.numberOfPlates.textColor = theme.tintColour
        
        
        return cell
    }
}

extension SettingsViewController: WeightTableViewCellDelegate {
    func weightTableViewCell(_ cell: WeightTableViewCell, numberOfPlatesDidChange newValue: Int) {
        guard let indexPath = setupTableView.indexPath(for: cell) else {
            return
        }
        
        let plate = plates[indexPath.row]
        settings.plateCount[plate] = newValue
        
    }
}
