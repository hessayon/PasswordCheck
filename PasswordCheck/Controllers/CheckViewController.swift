//
//  CheckViewController.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 02.10.2021.
//

import UIKit
import RealmSwift

class CheckViewController: UIViewController {
    
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var numbersSwitch: UISwitch!
    @IBOutlet weak var capitalLettersSwitch: UISwitch!
    @IBOutlet weak var specialSymbolsSwitch: UISwitch!
    
    let realm = try! Realm()
    
    private var groups: Results<Group>?
    // passwords where we are serching for input password
    private var passwords = [String]()
    private var pickerDataSource = ["None", "All groups"]
    private var minPasswordLength = 4
    private var capitalLettersRequired = false
    private var numbersRequired = false
    private var specialSymbolsRequired = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupPicker.dataSource = self
        groupPicker.delegate = self
        groups = realm.objects(Group.self)
        if let loadedGroups = groups {
            for group in loadedGroups {
                pickerDataSource.append(group.name)
            }
        }
        stepper.minimumValue = 4
        stepper.maximumValue = 30
    }
    @IBAction func stepperPressed(_ sender: UIStepper) {
        lengthTextField.text = Int(sender.value).description
        minPasswordLength = Int(sender.value)
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        if let password = passwordTextfield.text {
            if passwords.firstIndex(of: password) != nil || isEasy(password){
                let alert = UIAlertController(title: "The password is easy :(", message: "", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(actionOK)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "The password is safe :)", message: "", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(actionOK)
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func capitalLettersSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            capitalLettersRequired = true
        } else {
            capitalLettersRequired = false
        }
    }
    
    @IBAction func numbersSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            numbersRequired = true
        } else {
            numbersRequired = false
        }
    }
    @IBAction func specialSymbolsSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            specialSymbolsRequired = true
        } else {
            specialSymbolsRequired = false
        }
    }
    
}

//MARK: - UIPickerView methods

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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        passwords = []
        switch pickerDataSource[row] {
        case "None":
            return
        case "All groups":
            if let loadedGroups = groups {
                for group in loadedGroups {
                    for password in group.passwords {
                        passwords.append(password.title)
                    }
                }
            }
        default:
            if let loadedGroups = groups {
                let chosenGroups = loadedGroups.filter("name == %@", pickerDataSource[row])
                for group in chosenGroups {
                    for password in group.passwords {
                        passwords.append(password.title)
                    }
                }
            }
        }
    }
}

//MARK: - Password Check methods

extension CheckViewController {
    
    func isEasy(_ password: String) -> Bool {
        if password.count < minPasswordLength {
            return true
        }
        if capitalLettersRequired {
            let capitalLetterRegEx  = ".*[A-Z]+.*"
            if !(isMatches(regex: capitalLetterRegEx, password)) {
                return true
            }
        }
        if numbersRequired {
            let numberRegEx  = ".*[0-9]+.*"
            if !(isMatches(regex: numberRegEx, password)) {
                return true
            }
        }
        if specialSymbolsRequired {
            let specialSymbolsRegEx  = ".*[!&^%$#@()/]+.*"
            if !(isMatches(regex: specialSymbolsRegEx, password)) {
                return true
            }
        }
        return false
    }
    
    func isMatches(regex: String, _ password: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
}
