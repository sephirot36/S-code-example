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

class MainViewController: BaseViewController {
    // MARK: - @IBOutlets

    @IBOutlet var mapContainer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var reportButton: UIButton!

    // MARK: - Constants

    let disposeBag = DisposeBag()

    // MARK: - Variables

    var viewModel: MainViewModel?
    var mapController: GmapsController!

    // MARK: - Custom inits

    public init() {
        super.init(nibName: "MainViewController", bundle: Bundle(for: MainViewController.self))
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Initializer

    func initializer(viewModel: MainViewModel = MainViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))) {
        self.viewModel = viewModel
        viewModel.getTrips()
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setContainerControllers()
        self.addButtonActions()
        self.binds()
        self.callbacks()
    }

    // MARK: Private methods

    private func setContainerControllers() {
        let mapVc = GmapsController()
        mapVc.initializer(viewModel: MapViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/"))))
        self.mapController = mapVc

        self.mapContainer.addSubview(self.mapController.view)
    }

    private func addButtonActions() {
        self.reportButton.addTarget(self, action: #selector(self.showContactForm), for: .touchUpInside)
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
            .subscribe(
                onNext: { [weak self] trip in
                    self?.mapController.clearMap()
                    self?.mapController.drawLine(points: trip.coords ?? [])
                    self?.mapController.createMarkerAtLocation(
                        location: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(trip.origin.point._latitude),
                            longitude: CLLocationDegrees(trip.origin.point._longitude)),
                        icon: nil)
                    self?.mapController.createMarkerAtLocation(
                        location: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(trip.destination.point._latitude),
                            longitude: CLLocationDegrees(trip.destination.point._longitude)),
                        icon: nil)
                    self?.mapController.centerMapBetweenPoints(
                        origin: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(trip.origin.point._latitude),
                            longitude: CLLocationDegrees(trip.origin.point._longitude)),
                        end: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(trip.destination.point._latitude),
                            longitude: CLLocationDegrees(trip.destination.point._longitude)))

                    for stop in trip.stops {
                        self?.mapController.createMarkerAtLocationWithId(
                            location: CLLocationCoordinate2D(
                                latitude: CLLocationDegrees(stop.point?._latitude ?? 0.0),
                                longitude: CLLocationDegrees(stop.point?._longitude ?? 0.0)),
                            icon: GMSMarker.markerImage(with: .orange),
                            id: stop.id ?? -1)
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
                self.showAlert(title: "", message: requestError, closeButtonTitle: "Cerrar")
            }).disposed(by: self.disposeBag)
    }

    // MARK: - IBActions

    @objc func showContactForm(sender: UIButton!) {
        let contactVc = ContactFormViewController()
        contactVc.initializer(viewModel: ContactFormViewModel())
        showVC(vc: contactVc)
    }
}

// Extend Controller to perform UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
