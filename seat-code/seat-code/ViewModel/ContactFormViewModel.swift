//
//  ContactFormViewModel.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 09/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//
import RealmSwift
import RxCocoa
import RxSwift
import UserNotifications

class ContactFormViewModel {
    // MARK: - Constants
    
    let maxDescriptionChars: Int = 200
    let realm = try! Realm()
    
    // MARK: - Variables
    
    var inputUsername = BehaviorRelay<String>(value: "")
    var inputUserSurname = BehaviorRelay<String>(value: "")
    var inputMail = BehaviorRelay<String>(value: "")
    var inputPhone = BehaviorRelay<String>(value: "")
    var inputIssueDate = BehaviorRelay<String>(value: "")
    var inputIssueHour = BehaviorRelay<String>(value: "")
    var inputIssueDesc = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable<Bool>.combineLatest(inputUsername.asObservable(),
                                              inputUserSurname.asObservable(),
                                              inputMail.asObservable(),
                                              inputIssueDate.asObservable(),
                                              inputIssueHour.asObservable(),
                                              inputIssueDesc.asObservable(),
                                              resultSelector: { (username, surname, mail, date, hour, desc) -> Bool in
                                                  !username.isEmpty && !surname.isEmpty &&
                                                      !mail.isEmpty && !date.isEmpty &&
                                                      !hour.isEmpty && !desc.isEmpty
        })
    }
    
    public func saveIssue(issue: Issue) {
        realm.beginWrite()
        realm.add(issue)
        try! realm.commitWrite()
    }
    
    public func updateBadge() {
        let issues = realm.objects(Issue.self)
        let application = UIApplication.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) {
            granted, _ in
            // Parse errors and track state
            if !granted {
                print("Permisos denegados para informar de la cantidad de incidencias abiertas")
            }
        }
        application.applicationIconBadgeNumber = issues.count
    }
}
