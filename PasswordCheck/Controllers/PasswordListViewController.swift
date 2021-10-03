//
//  PasswordListViewController.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 02.10.2021.
//

import UIKit

class PasswordListViewController: UITableViewController {
    private let passwords = ["qwerty", "123456", "abcdef", "password"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath)
        cell.textLabel?.text = passwords[indexPath.row]
        return cell
        
    }


}
