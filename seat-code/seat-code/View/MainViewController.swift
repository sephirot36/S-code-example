//
//  ViewController.swift
//  seat-code
//
//  Created by Daniel Castro muñoz on 02/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps
import RxCocoa
import RxSwift
import UIKit

class MainViewController: UIViewController {
    // MARK: - @IBOutlets

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

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
        self.callbacks()
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

    private func callbacks() {
        guard let viewModel = viewModel else {
            print("No viewModel available")
            return
        }
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let `self` = self else { return }
                self.tableView.isHidden = isLoading
                self.loadingIndicator.isHidden = !isLoading
            }).disposed(by: self.disposeBag)
        
        viewModel.requestError
        .subscribe(onNext: { [weak self] requestError in
            guard let `self` = self else { return }
            self.showAlert(message: requestError)
        }).disposed(by: self.disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// Extend Controller to perform UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Try to return dynamic height depending of the content of summary
        return 80
    }
}
