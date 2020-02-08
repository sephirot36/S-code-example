//
//  Issue.swift
//  seat-code
//
//  Created by Daniel Castro on 07/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//
import Foundation
import RealmSwift

class Issue: Object {
    @objc dynamic var userName = ""
    @objc dynamic var userSurname = ""
    @objc dynamic var userEmail = ""
    @objc dynamic var userPhone = ""
    @objc dynamic var issueDate = ""
    @objc dynamic var issueHour = ""
    @objc dynamic var userIssueDescription = ""
}
