//
//  SettingsViewController.swift
//  Barbell Plate Calculator
//
//  Created by Robert Oneill on 25/06/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import UIKit

class WeightTableViewCell: UITableViewCell {
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var numberOfPlates: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        numberOfPlates.text = Int(sender.value).description
        
        
    }
    
    struct WeightSettings: stepperProtocol {
        var weightSelected: [String : Int] = [:]
        
        var weightAmount: Int
        
        var weightType: String
        
        
        
    }
    
}

protocol stepperProtocol {
    var weightSelected: [String:Int] {get}
    var weightType: String {get}
    var weightAmount: Int {get}

    
    
}






class SettingsViewController: UIViewController {
    
    var plates = Plate.allCases
    
    @IBOutlet weak var setupTableView: UITableView!
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        
        
        }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

}

extension SettingsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plates.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! WeightTableViewCell
        
        
        let allPlates = plates[indexPath.row]
        cell.weightLabel.text = "\(allPlates.kg) KG"
        
        
        
        return cell
    }
    
    
    
}
