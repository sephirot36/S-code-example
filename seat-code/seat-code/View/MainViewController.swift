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

    @IBOutlet var mapContainer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    // MARK: - Constants

    let disposeBag = DisposeBag()

    // MARK: - Variables

    var viewModel: MainViewModel? = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))

    var mapController: GmapsController!

    // MARK: Initializer

    func initializer(viewModel: MainViewModel = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))) {
        self.viewModel = viewModel
    }

    // MARK: - TODO: Check Constrains on my phone

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setContainerControllers()
        self.binds()
        self.callbacks()
    }

    // MARK: Private methods

    private func setContainerControllers() {
        var mapCont: GmapsController? {
            return children.firstMatchingType()!
        }
        self.mapController = mapCont
    }

    private func binds() {
        guard let viewModel = self.viewModel else {
            print("No viewModel available")
            return
        }

        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)

        self.tableView.register(UINib(nibName: "TripTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TripTableViewCell.self))

        viewModel.trips.bind(to: self.tableView.rx.items(cellIdentifier: "TripTableViewCell", cellType: TripTableViewCell.self)) { _, trip, cell in
            cell.cellTrip = trip
        }.disposed(by: self.disposeBag)

        // TODO: SAVE points as CLLocationCoordinate2D when parsing
        self.tableView.rx.modelSelected(Trip.self)
            .subscribe(onNext: { [weak self] trip in
                self?.mapController.clearMap()
                self?.mapController.drawLine(points: trip.routeCoords)
                self?.mapController.createMarkerAtLocation(location: CLLocationCoordinate2D(latitude: CLLocationDegrees(trip.origin.point.latitude), longitude: CLLocationDegrees(trip.origin.point.longitude)), icon: nil)
                self?.mapController.createMarkerAtLocation(location: CLLocationCoordinate2D(latitude: CLLocationDegrees(trip.destination.point.latitude), longitude: CLLocationDegrees(trip.destination.point.longitude)), icon: nil)
                self?.mapController.centerMapBetweenPoints(origin: CLLocationCoordinate2D(latitude: CLLocationDegrees(trip.origin.point.latitude),
                                                                                          longitude: CLLocationDegrees(trip.origin.point.longitude)), end: CLLocationCoordinate2D(latitude: CLLocationDegrees(trip.destination.point.latitude), longitude: CLLocationDegrees(trip.destination.point.longitude)))

                for stop in trip.stops {
                    self?.mapController.createMarkerAtLocationWithId(location: CLLocationCoordinate2D(latitude: CLLocationDegrees(stop.point.point.latitude), longitude: CLLocationDegrees(stop.point.point.longitude)), icon: GMSMarker.markerImage(with: .orange), id: stop.id)
                }
            }).disposed(by: self.disposeBag)
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
