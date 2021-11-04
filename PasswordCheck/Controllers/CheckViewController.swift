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

    let realm = try! Realm()
    private var groups: Results<Group>?
    // passwords where we are serching for input password
    private var passwords = [String]()
    private var pickerDataSource = ["None", "All groups"]
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
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        if let password = passwordTextfield.text {
            if passwords.firstIndex(of: password) != nil {
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
        print(passwords)
    }
}
