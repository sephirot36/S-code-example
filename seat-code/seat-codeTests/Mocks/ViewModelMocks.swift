//
//  ViewModelMocks.swift
//  seat-codeTests
//
//  Created by Daniel Castro on 09/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

@testable import seat_code

class ContactFormViewModelMock: ContactFormViewModel {
    
    var saveIssueCalled = false
    var updateBadgeCalled = false
    
    override func saveIssue(issue: Issue) {
        saveIssueCalled = true
    }
    
    override func updateBadge() {
        updateBadgeCalled = true
    }
}
