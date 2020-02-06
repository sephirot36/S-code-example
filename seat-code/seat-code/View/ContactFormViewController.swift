//
//  ContactFormViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 06/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import UIKit

class ContactFormViewController: UIViewController {
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
