//
//  SettingsViewController.swift
//  My Contact List
//
//  Created by user246123 on 3/5/24.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var lblBattery: UILabel!
    
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pckSortField.dataSource = self;
        pckSortField.delegate = self;
        
        // Battery Monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        self.batteryChanged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let device = UIDevice.current
        print("Device Info:")
        print("Name: \(device.name)")
        print("Model: \(device.model)")
        print("System Name: \(device.systemName)")
        print("System Version: \(device.systemVersion)")
        print("Identifier: \(device.identifierForVendor!)")
        
        let orientation: String
        switch device.orientation {
        case .faceDown:
            orientation = "Face Down"
        case .landscapeLeft:
            orientation = "Landscape Left"
        case .portrait:
            orientation = "Portrait"
        case .landscapeRight:
            orientation = "Landscape Right"
        case .faceUp:
            orientation = "Face Up"
        case .portraitUpsideDown:
            orientation = "Portrait Upside Down"
        case .unknown:
            orientation = "Unknown Orientation"
        @unknown default:
            fatalError()
        }
        print("Orientation: \(orientation)")
    }
    
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
    
    // MARK: UIPickerViewDelegate Methods
    
    // returns the number of 'columns' to display
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    // Sets the value that is shown for each row in the picker
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    //If the user chooses from the pickerview, it calls this function
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // set the UI based on the values in UserDefaults
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        let sortField = settings.string(forKey: Constants.kSortField)
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0)
    }
    
    
    @objc func batteryChanged () {
        let device = UIDevice.current
        var batteryState: String
        switch(device.batteryState) {
        case .charging:
            batteryState = "+"
        case .full:
            batteryState = "!"
        case .unplugged:
            batteryState = "-"
        case .unknown:
            batteryState = "?"
        }
        
        let batteryLevelPercent = device.batteryLevel * 100
        let batteryLevel = String(format: "%.0f%%", batteryLevelPercent)
        let batteryStatus = "\(batteryLevel) (\(batteryState))"
        lblBattery.text = batteryState
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
