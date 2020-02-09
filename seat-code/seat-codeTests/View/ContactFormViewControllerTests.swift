//
//  ContactFormViewControllerTests.swift
//  seat-codeTests
//
//  Created by Daniel Castro on 09/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import Nimble
import Quick

@testable import seat_code

class ContactFormViewControllerTests: QuickSpec {
    override func spec() {
        var subject: ContactFormViewController!
        let viewModelMock: ContactFormViewModelMock = ContactFormViewModelMock()
        
        describe("ContactFormViewControllerSpec") {
            beforeEach {
                subject = ContactFormViewController()
                subject.initializer(viewModel: viewModelMock)
                
                _ = subject.view
            }
            
            context("when view is loaded") {
                it("inputName should be empty") {
                    expect(subject.inputName.text).to(equal(""))
                }
                
                it("inputSurname should be empty") {
                    expect(subject.inputSurname.text).to(equal(""))
                }
                
                it("inputMail should be empty") {
                    expect(subject.inputSurname.text).to(equal(""))
                }
                
                it("inputMail should be empty") {
                    expect(subject.inputMail.text).to(equal(""))
                }
                
                it("inputPhone should be empty") {
                    expect(subject.inputPhone.text).to(equal(""))
                }
                
                it("inputDate should be empty") {
                    expect(subject.inputDate.text).to(equal(""))
                }
                
                it("inputHour should be empty") {
                    expect(subject.inputHour.text).to(equal(""))
                }
                
                it("inputDescription should be empty") {
                    expect(subject.inputDescription.text).to(equal(""))
                }
            }
            
            context("when send form without filling fields") {
                it("should not call viewModel saveIssue") {
                    subject.sendButton.sendActions(for: .touchUpInside)
                    expect(viewModelMock.saveIssueCalled).to(beFalse())
                }
            }
            
            context("when send with mandatory fields filled") {
                it("should call viewModel saveIssue") {
                    subject.inputName.text = "inputName"
                    subject.inputSurname.text = "inputSurname"
                    subject.inputMail.text = "inputMail"
                    subject.inputDate.text = "inputDate"
                    subject.inputHour.text = "inputHour"
                    subject.inputDescription.text = "inputDescription"
                    
                    subject.sendButton.sendActions(for: .touchUpInside)
                    expect(viewModelMock.saveIssueCalled).to(beTrue())
                    expect(viewModelMock.updateBadgeCalled).to(beTrue())
                }
            }
        }
    }
}
