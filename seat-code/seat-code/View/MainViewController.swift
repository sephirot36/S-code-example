//
//  ViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps
import UIKit

class MainViewController: UIViewController {
    // MARK: - @IBOutlets

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var tableView: UITableView!

    // MARK: - Variables

    var viewModel: MainViewModel = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))

    // MARK: Initializer

    func initializer(viewModel: MainViewModel = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))) {
        self.viewModel = viewModel
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
