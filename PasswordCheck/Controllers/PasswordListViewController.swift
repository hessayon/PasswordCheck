//
//  PasswordListViewController.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 02.10.2021.
//

import UIKit
import RealmSwift

class PasswordListViewController: SwipeTableViewController {
    
    var passwords: Results<Password>?
    let realm = try! Realm()
    var selectedGroup : Group? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        if let safeCategory = selectedGroup {
            title = safeCategory.name
        }
        

    }
    //MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let password = passwords?[indexPath.row] {
            cell.textLabel?.text = password.title

        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: - Add New Items
    
    private var alert : UIAlertController?
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
            alert?.actions[0].isEnabled = sender.text!.count > 0
        }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add Item", style: .cancel) { (action) in
            if let currentGroup = self.selectedGroup{
                do{
                    try self.realm.write({
                        let newPassword = Password()
                        newPassword.title = textField.text!
                        newPassword.dateCreated = Date()
                        currentGroup.passwords.append(newPassword)
                    })
                }catch{
                    print("Error saving new items, \(error)")
                }

            }
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert?.addTextField { alertTextField in
            alertTextField.placeholder = "Create new password"
            alertTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField = alertTextField

        }
        actionAdd.isEnabled = false
        alert?.addAction(actionAdd)
        alert?.addAction(actionCancel)
        present(alert!, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Manupulation Methods


    func loadItems() {
        passwords = selectedGroup?.passwords.sorted(byKeyPath: "dateCreated",ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Item From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let passwordForDeletion = passwords?[indexPath.row] {
            do {
                try realm.write({
                    self.realm.delete(passwordForDeletion)
                })
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}
