//
//  GroupViewController.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 02.10.2021.
//

import UIKit
import RealmSwift
import MobileCoreServices
import UniformTypeIdentifiers

class GroupViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    private var groups: Results<Group>?
    private var passwordsFromFile = [String]()
    private var groupCreatedFromFile = Group()
    private var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroups()
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 1 // if groups == nil: return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = groups?[indexPath.row] {
            cell.textLabel?.text = category.name
        }

        return cell
    }
    
    //MARK: - Data Manipulation Methods
    

    func loadGroups() {
        
        groups = realm.objects(Group.self)
        tableView.reloadData()
    }
    
    func save(group: Group) {
        do {
            try realm.write({
                if groups?.filter("name == %@", group.name).count == 0 {
                    realm.add(group)
                } else {
                    let errorAlert = UIAlertController(title: "Duplicate!", message: "Found group with the same name.\nTry again!", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    present(errorAlert, animated: true, completion: nil)
                }
                
            })
        }catch {
            print("Error saving categoty \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Category from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let groupForDeletion = self.groups?[indexPath.row]{
            do {
                try realm.write({
                    self.realm.delete(groupForDeletion)
                })
                
            } catch {
                print("Error deleting group, \(error)")
            }
        }
    }
    

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPasswords", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PasswordListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedGroup = groups?[indexPath.row]
            }
        }
    }
    
    //MARK: - Add New Group
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        alert = UIAlertController(title: "Create New Group", message: "Choose how to create a new group", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert?.addAction(UIAlertAction(title: "Create Empty Group", style: .default) { (action) in
            self.createEmptyGroup()
        })
        alert?.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert?.addAction(UIAlertAction(title: "Create Group From File", style: .default){ (action) in
            self.createGroupFromFile()
        })
        // show the alert
        self.present(alert!, animated: true, completion: nil)

    }

}

//MARK: - UIDocumentPickerDelegate methods

extension GroupViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        do{
            let savedData = try String(contentsOf: selectedFileURL)
            let passwords = savedData.split(separator: ",")
            for password in passwords{
                let newPassword = Password()
                newPassword.title = password.trimmingCharacters(in: .whitespacesAndNewlines)
                newPassword.dateCreated = Date()
                self.groupCreatedFromFile.passwords.append(newPassword)
                passwordsFromFile.append(password.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            self.save(group: self.groupCreatedFromFile)
            self.groupCreatedFromFile = Group()
            self.passwordsFromFile = []
                
        } catch {
            print(error.localizedDescription)
        }
    }
}


//MARK: - Methods of creating groups

extension GroupViewController {
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
            alert?.actions[0].isEnabled = sender.text!.count > 0
        }
    
    func createEmptyGroup() {
        var textField = UITextField()
        alert = UIAlertController(title: "Add New Group", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add Group", style: .cancel) { (action) in
            let newGroup = Group()
            newGroup.name = textField.text!
            self.save(group: newGroup)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        alert?.addTextField { alertTextField in
            alertTextField.placeholder = "Create new group"
            alertTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField = alertTextField
            
        }
        actionAdd.isEnabled = false
        alert?.addAction(actionAdd)
        alert?.addAction(actionCancel)
        self.present(alert!, animated: true, completion: nil)
    }
    
    func createGroupFromFile() {
        alert = UIAlertController(title: "Add New Group", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let actionChooseFile = UIAlertAction(title: "Choose file", style: .cancel) { (action) in
            self.groupCreatedFromFile.name = textField.text!
            let types = UTType.types(tag: "txt",
                                         tagClass: UTTagClass.filenameExtension,
                                         conformingTo: nil)
            let documentPicker = UIDocumentPickerViewController(
                    forOpeningContentTypes: types)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert?.addTextField { alertTextField in
            alertTextField.placeholder = "Create new group"
            alertTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField = alertTextField
            
        }
        actionChooseFile.isEnabled = false
        alert?.addAction(actionChooseFile)
        alert?.addAction(actionCancel)
        self.present(alert!, animated: true, completion: nil)
        
    }
}
