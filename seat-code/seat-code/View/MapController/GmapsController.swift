//
//  GmapsController.swift
//  seat-code
//
//  Created by Daniel Castro on 05/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps
import RxCocoa
import RxSwift

class GmapsController: UIViewController, MapControllerProtocol {
    // MARK: - @IBOutlets
    
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: - Constants
    
    let disposeBag = DisposeBag()
    let mapZoom: Float = 11
    
    // MARK: - Variables
    
    var viewModel: MapViewModel? = MapViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))
    var selectedMarker: GMSMarker = GMSMarker()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.callbacks()
    }
    
    // MARK: Private methods
    
    private func callbacks() {
        guard let viewModel = viewModel else {
            print("No viewModel available")
            return
        }
        viewModel.stopInfo
            .subscribe(onNext: { [weak self] stopInfo in
                guard let `self` = self else { return }
                self.openMarkerInfo(title: stopInfo.address, snippet: stopInfo.userName)
            }).disposed(by: self.disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MapControllerProtocol conformance
    
    func clearMap() {
        self.mapView.clear()
    }
    
    func centerMapBetweenPoints(origin: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let bounds = GMSCoordinateBounds(coordinate: origin, coordinate: end)
        
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30))
        self.mapView.moveCamera(update)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D, zoom: Float) {
        self.mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
    }
    
    func createMarkerAtLocation(location: CLLocationCoordinate2D, icon: UIImage?) {
        let marker = GMSMarker(position: location)
        if let icon = icon {
            marker.icon = icon
        }
        marker.map = self.mapView
    }
    
    func createMarkerAtLocationWithId(location: CLLocationCoordinate2D, icon: UIImage?, id: Int) {
        let marker = GMSMarker(position: location)
        marker.userData = id
        if let icon = icon {
            marker.icon = icon
        }
        marker.map = self.mapView
    }
    
    func drawLine(points: [CLLocationCoordinate2D]) {
        let path = GMSMutablePath()
        for point in points {
            path.add(point)
        }
        
        let route = GMSPolyline(path: path)
        route.map = self.mapView
    }
    
    func openMarkerInfo(title: String, snippet: String) {
        self.selectedMarker.title = title
        self.selectedMarker.snippet = snippet
        self.selectedMarker.tracksInfoWindowChanges = true
        self.mapView.selectedMarker = self.selectedMarker
        self.centerMapOnLocation(location: self.selectedMarker.position, zoom: mapZoom)
    }
}

extension GmapsController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let markerId = marker.userData {
            marker.tracksInfoWindowChanges = true
            marker.title = "Cargando..."
            marker.snippet = nil
            self.centerMapOnLocation(location: marker.position, zoom: mapZoom)
            self.mapView.selectedMarker = marker
            self.selectedMarker = marker
            self.viewModel?.getStopInfo(id: markerId as! Int)
        } else {
            self.showAlert(message: "No hay información disponible")
        }
        return true
    }
}
