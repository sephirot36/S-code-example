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
    // MARK: - Variables
    
    var viewModel: ContactFormViewModel?
    
    // MARK: - @IBOutlets
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputName: UITextField!
    @IBOutlet var inputSurname: UITextField!
    @IBOutlet var inputMail: UITextField!
    @IBOutlet var inputPhone: UITextField!
    @IBOutlet var inputDate: UITextField!
    @IBOutlet var inputHour: UITextField!
    @IBOutlet var inputDescription: UITextView!
    
    // MARK: - Custom inits
    
    public init() {
        super.init(nibName: "ContactFormViewController", bundle: Bundle(for: ContactFormViewController.self))
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Initializer
    
    func initializer(viewModel: ContactFormViewModel = ContactFormViewModel()) {
        self.viewModel = viewModel
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
    
    private func isValidForm() -> Bool {
        guard let viewModel = self.viewModel else {
            print("No viewModel defined")
            return false
        }
        let validName = viewModel.checkEmptyString(string: inputName.text)
        let validSurname = viewModel.checkEmptyString(string: inputSurname.text)
        // TODO: Check correct email syntax with RegEx
        let validMail = viewModel.checkEmptyString(string: inputMail.text)
        let validDesc = viewModel.checkEmptyString(string: inputDescription.text)
        // TODO: Check Date & Hour formats
        let validDate = viewModel.checkEmptyString(string: inputDate.text)
        let validHour = viewModel.checkEmptyString(string: inputHour.text)
        
        if validName, validSurname,
            validMail, validDesc,
            validDate, validHour {
            return true
        } else {
            return false
        }
    }
    
    private func showSuccess() {
        let extraAction = UIAlertAction(title: "Volver", style: .default) { (_: UIAlertAction) in
            self.closeView()
        }
        showAlertWithAction(title: "Solicitud enviada correctamente", message: "Gracias por informarnos del problema", extraAction: extraAction)
    }
    
    // MARK: - IBActions
    
    @objc func cancelAction(sender: UIButton!) {
        closeView()
    }
    
    @objc func sendAction(sender: UIButton!) {
        guard let viewModel = self.viewModel else {
            print("No viewModel defined")
            return
        }
        if isValidForm() {
            let issue = Issue()
            issue.userName = inputName.text ?? ""
            issue.userSurname = inputSurname.text ?? ""
            issue.userEmail = inputMail.text ?? ""
            issue.userPhone = inputPhone.text ?? ""
            issue.userIssueDescription = inputDescription.text ?? ""
            viewModel.saveIssue(issue: issue)
            viewModel.updateBadge()
            showSuccess()
        } else {
            showAlert(title: "", message: "Debes rellenar los campos obligatorios", closeButtonTitle: "Cerrar")
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
        guard let viewModel = self.viewModel else {
            print("No viewModel defined")
            return false
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < viewModel.maxDescriptionChars
    }
}
