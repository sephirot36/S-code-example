//
//  ContactFormViewModel.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 09/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//
import RealmSwift
import UserNotifications

class ContactFormViewModel {
    // MARK: - Constants
    
    let maxDescriptionChars: Int = 200
    let realm = try! Realm()
    
    public func saveIssue(issue: Issue) {
        // Save your object
        realm.beginWrite()
        realm.add(issue)
        try! realm.commitWrite()
    }
    
    public func checkEmptyString(string: String?) -> Bool {
        guard let string = string else {
            return false
        }
        return !string.isEmpty
    }
    
    public func updateBadge() {
        let issues = realm.objects(Issue.self)
        let application = UIApplication.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) {
            (granted, error) in
            //Parse errors and track state
            if !granted {
                print("Permisos denegados para informar de la cantidad de incidencias abiertas")
            }
        }
        application.applicationIconBadgeNumber = issues.count
    }
}
