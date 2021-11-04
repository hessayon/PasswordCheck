//
//  AppDelegate.swift
//  PasswordCheck
//
//  Created by Margo Naumenko on 26.09.2021.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {




    //This gets called when the app gets loaded up. (Before viewDidLoad)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        do{
            let _ = try Realm()
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }


}

