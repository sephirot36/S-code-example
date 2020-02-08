//
//  BaseViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 08/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    func closeView() {
        dismiss(animated: true, completion: nil)
    }

    func showAlert(title: String, message: String, closeButtonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: closeButtonTitle, style: .default, handler: nil)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showAlertWithAction(title: String, message: String, closeButtonTitle: String? = nil, extraAction: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(extraAction)
        if let closeTitle = closeButtonTitle {
            let closeAction = UIAlertAction(title: closeTitle, style: .default, handler: nil)
            alert.addAction(closeAction)
        }
        self.present(alert, animated: true, completion: nil)
    }

    func showVC(vc: UIViewController) {
        self.show(vc, sender: nil)
    }
}
