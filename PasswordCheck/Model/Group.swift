//
//  Group.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 03.11.2021.
//

import Foundation
import RealmSwift

class Group: Object {
    @objc dynamic var name: String = ""
    let passwords = List<Password>() // relationships with Password class
}

