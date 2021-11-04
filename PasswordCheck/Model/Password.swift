//
//  Password.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 03.11.2021.
//

import Foundation
import RealmSwift

class Password : Object{
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Group.self, property: "passwords" ) //relationships with Category class
}
