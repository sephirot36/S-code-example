//
//  ContactFormViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 06/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import RealmSwift
import UIKit

class ContactFormViewController: BaseViewController {
    // MARK: - Constants
    
    let maxDescriptionChars: Int = 200
    let realm = try! Realm()
    
    // MARK: - @IBOutlets
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputName: UITextField!
    @IBOutlet var inputSurname: UITextField!
    @IBOutlet var inputMail: UITextField!
    @IBOutlet var inputPhone: UITextField!
    @IBOutlet var inputDescription: UITextView!
    
    // MARK: - Custom inits
    
    public init() {
        super.init(nibName: "ContactFormViewController", bundle: Bundle(for: ContactFormViewController.self))
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addActions()
        setDelegates()
    }
    
    // MARK: - Private methods
    
    private func addActions() {
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
    }
    
    private func setDelegates() {
        inputName.delegate = self
        inputSurname.delegate = self
        inputMail.delegate = self
        inputPhone.delegate = self
        inputDescription.delegate = self
    }
    
    private func saveIssue(issue: Issue) {
        // Save your object
        realm.beginWrite()
        realm.add(issue)
        try! realm.commitWrite()
    }
    
    private func checkEmptyString(string: String?) -> Bool {
        guard let string = string else {
            return false
        }
        return !string.isEmpty
    }
    
    private func isValidForm() -> Bool {
        let validName = checkEmptyString(string: inputName.text)
        let validSurname = checkEmptyString(string: inputSurname.text)
        // TODO: Check correct email syntax with RegEx
        let validMail = checkEmptyString(string: inputMail.text)
        let validDesc = checkEmptyString(string: inputDescription.text)
        
        if validName, validSurname, validMail, validDesc {
            return true
        } else {
            return false
        }
    }
    
    private func updateBadge() {
        let issues = realm.objects(Issue.self)
        let application = UIApplication.shared
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: .badge, categories: nil))
        
        application.applicationIconBadgeNumber = issues.count
    }
    
    // MARK: - IBActions
    
    @objc func cancelAction(sender: UIButton!) {
        closeView()
    }
    
    @objc func sendAction(sender: UIButton!) {
        if isValidForm() {
            let issue = Issue()
            issue.userName = inputName.text ?? ""
            issue.userSurname = inputSurname.text ?? ""
            issue.userEmail = inputMail.text ?? ""
            issue.userPhone = inputPhone.text ?? ""
            issue.userIssueDescription = inputDescription.text ?? ""
            saveIssue(issue: issue)
            updateBadge()
        } else {
            showAlert(message: "Debes rellenar los campos obligatorios", closeButtonTitle: "Cerrar")
        }
    }
}

extension ContactFormViewController: UITextFieldDelegate {
    // MARK: UITextFieldDelegate conformance
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputName {
            textField.resignFirstResponder()
            inputSurname.becomeFirstResponder()
        } else if textField == inputSurname {
            textField.resignFirstResponder()
            inputMail.becomeFirstResponder()
        } else if textField == inputMail {
            textField.resignFirstResponder()
            inputPhone.becomeFirstResponder()
        } else if textField == inputPhone {
            inputDescription.resignFirstResponder()
        }
        return true
    }
}

extension ContactFormViewController: UITextViewDelegate {
    // MARK: UITextViewDelegate conformance
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxDescriptionChars
    }
}
