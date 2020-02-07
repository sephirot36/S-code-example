//
//  ContactFormViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 06/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import UIKit

class ContactFormViewController: UIViewController {
   
    // MARK: - Constants
     let maxDescriptionChars: Int = 200
    
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
    
    // MARK: - IBActions
    
    @objc func cancelAction(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendAction(sender: UIButton!) {}
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < maxDescriptionChars    // 10 Limit Value
    }
}