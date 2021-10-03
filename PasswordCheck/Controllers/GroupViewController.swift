//
//  GroupViewController.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 02.10.2021.
//

import UIKit

class GroupViewController: UITableViewController {
    
    private let groups = ["Group 1", "Group 2", "Group 3", "Group 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]
        return cell
        
    }

}
