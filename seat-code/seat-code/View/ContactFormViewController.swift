//
//  ContactFormViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 06/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxSwift
import UIKit

class ContactFormViewController: BaseViewController {
    // MARK: - Constants
    
    let disposeBag = DisposeBag()
    
    // MARK: - Variables
    
    var viewModel: ContactFormViewModel?
    var isValid: Bool = false
    
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
        binds()
        setDelegates()
        callbacks()
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
        inputDate.delegate = self
        inputHour.delegate = self
        inputDescription.delegate = self
    }
    
    private func binds() {
        guard let viewModel = self.viewModel else {
            print("No viewModel available")
            return
        }
        
        inputName.rx.text.orEmpty.bind(to: viewModel.inputUsername).disposed(by: disposeBag)
        inputSurname.rx.text.orEmpty.bind(to: viewModel.inputUserSurname).disposed(by: disposeBag)
        inputMail.rx.text.orEmpty.bind(to: viewModel.inputMail).disposed(by: disposeBag)
        inputPhone.rx.text.orEmpty.bind(to: viewModel.inputPhone).disposed(by: disposeBag)
        inputDate.rx.text.orEmpty.bind(to: viewModel.inputIssueDate).disposed(by: disposeBag)
        inputHour.rx.text.orEmpty.bind(to: viewModel.inputIssueHour).disposed(by: disposeBag)
        inputDescription.rx.text.orEmpty.bind(to: viewModel.inputIssueDesc).disposed(by: disposeBag)
    }
    
    private func callbacks() {
        guard let viewModel = viewModel else {
            print("No viewModel available")
            return
        }
        viewModel.isValid
            .subscribe(onNext: { [weak self] isValid in
                guard let `self` = self else { return }
                self.isValid = isValid
            }).disposed(by: disposeBag)
    }
    
    private func showSuccess() {
        let extraAction = UIAlertAction(title: "Volver", style: .default) { (_: UIAlertAction) in
            self.closeView()
        }
        showAlertWithAction(title: "Solicitud enviada correctamente", message: "Gracias por informarnos del problema", extraAction: extraAction)
    }
    
    private func sendForm() {
        guard let viewModel = self.viewModel else {
            print("No viewModel defined")
            return
        }
        if isValid {
            let issue = Issue()
            issue.userName = inputName.text ?? ""
            issue.userSurname = inputSurname.text ?? ""
            issue.userEmail = inputMail.text ?? ""
            issue.userPhone = inputPhone.text ?? ""
            issue.issueDate = inputDate.text ?? ""
            issue.issueHour = inputHour.text ?? ""
            issue.userIssueDescription = inputDescription.text ?? ""
            viewModel.saveIssue(issue: issue)
            viewModel.updateBadge()
            showSuccess()
        } else {
            showAlert(title: "", message: "Debes rellenar los campos obligatorios", closeButtonTitle: "Cerrar")
        }
    }
    
    // MARK: - IBActions
    
    @objc func cancelAction(sender: UIButton!) {
        closeView()
    }
    
    @objc func sendAction(sender: UIButton!) {
        sendForm()
    }
}

extension ContactFormViewController: UITextFieldDelegate {
    // MARK: UITextFieldDelegate conformance
    
    // This it seems it's not working with rx.text.orEmpty.bind
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
            textField.resignFirstResponder()
            inputDate.becomeFirstResponder()
        } else if textField == inputDate {
            textField.resignFirstResponder()
            inputHour.becomeFirstResponder()
        } else if textField == inputHour {
            inputDescription.becomeFirstResponder()
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
            sendForm()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < viewModel.maxDescriptionChars
    }
}
