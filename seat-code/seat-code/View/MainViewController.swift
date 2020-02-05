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

    // MARK: - TODO: Check Constrains on my phone

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.binds()
        self.callbacks()
    }

    // MARK: Private methods

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

        self.tableView.rx.modelSelected(Trip.self)
            .subscribe(onNext: { [weak self] trip in
                self?.loadRoute(routePoints: trip.routeCoords)
                self?.createMarkerAt(point: trip.origin.point)
                self?.createMarkerAt(point: trip.destination.point)
                self?.displayStops(stops: trip.stops)
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

    // MARK: Public methods

    public func loadRoute(routePoints: [CLLocationCoordinate2D]) {
        self.mapView.clear()
        let path = GMSMutablePath()
        for point in routePoints {
            path.add(point)
        }

        let route = GMSPolyline(path: path)
        route.map = self.mapView

        let bounds = GMSCoordinateBounds(coordinate: routePoints[0], coordinate: routePoints[routePoints.count - 1])

        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30))
        self.mapView.moveCamera(update)
    }

    public func createMarkerAt(point: Point, color: UIColor = .clear) {
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(point.latitude), longitude: CLLocationDegrees(point.longitude))
        let marker = GMSMarker(position: position)

        if color != .clear {
            marker.icon = GMSMarker.markerImage(with: color)
        }

        marker.map = self.mapView
    }

    public func displayStops(stops: [Stop]) {
        for stop in stops {
            self.createMarkerAt(point: stop.point.point, color: .orange)
        }
    }
}

// Extend Controller to perform UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Try to return dynamic height depending of the content of summary
        return 80
    }
}
