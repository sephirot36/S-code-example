//
//  ViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps
import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    // MARK: - @IBOutlets

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var tableView: UITableView!

    // MARK: - Constants

    let disposeBag = DisposeBag()

    // MARK: - Variables

    var viewModel: MainViewModel? = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))

    // MARK: Initializer

    func initializer(viewModel: MainViewModel = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))) {
        self.viewModel = viewModel
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.binds()
    }

    // MARK: Private methods

    private func binds() {
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.tableView.register(UINib(nibName: "TripTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TripTableViewCell.self))
        
        self.viewModel?.trips.bind(to: self.tableView.rx.items(cellIdentifier: "TripTableViewCell", cellType: TripTableViewCell.self)) { _, trip, cell in
            cell.cellTrip = trip
        }.disposed(by: self.disposeBag)
    }
}

// Extend Controller to perform UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Try to return dynamic height depending of the content of summary
        return 130
    }
}
