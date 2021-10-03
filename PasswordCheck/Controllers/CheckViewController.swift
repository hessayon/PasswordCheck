//
//  CheckViewController.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 02.10.2021.
//

import UIKit

class CheckViewController: UIViewController {
    @IBOutlet weak var groupPicker: UIPickerView!
    private let pickerDataSource = ["None","All groups","Group 1", "Group 2", "Group 3", "Group 4" ]
    override func viewDidLoad() {
        super.viewDidLoad()
        groupPicker.dataSource = self
        groupPicker.delegate = self
        
    }


}

extension CheckViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    
}
