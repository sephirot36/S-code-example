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

class GmapsController: BaseViewController, MapControllerProtocol {
    // MARK: - @IBOutlets
    
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: - Constants
    
    let disposeBag = DisposeBag()
    let mapZoom: Float = 11
    let loadingText = "Cargando..."
    
    // MARK: - Variables
    
    var viewModel: MapViewModel?
    var selectedMarker: GMSMarker = GMSMarker()
    
    // MARK: - Custom inits
    
    public init() {
        super.init(nibName: "MapViewController", bundle: Bundle(for: GmapsController.self))
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Initializer
    
    func initializer(viewModel: MapViewModel = MapViewModel(resourcesApi: ResourcesApi(dataProvider: NetworkProvider(baseURL: "https://europe-west1-metropolis-fe-test.cloudfunctions.net/api/")))) {
        self.viewModel = viewModel
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.callbacks()
        // TODO: Center on user's location????
        // Center map in Bcn coords
        self.centerMapOnLocation(location: CLLocationCoordinate2D(latitude: 41.4021919, longitude: 2.1428796), zoom: self.mapZoom)
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
                let snippet = "\(stopInfo.userName) (\(self.getDate(stop: stopInfo)))"
                self.openMarkerInfo(title: stopInfo.address, snippet: snippet)
            }).disposed(by: self.disposeBag)
        
        viewModel.requestError
            .subscribe(onNext: { [weak self] requestError in
                guard let `self` = self else { return }
                self.clearMarkerInfo()
                let extraAction = UIAlertAction(title: "Reportar incidencia", style: .default) { (_: UIAlertAction) in
                    let contactVc = ContactFormViewController()
                    contactVc.initializer(viewModel: ContactFormViewModel())
                    self.showVC(vc: contactVc)
                }
                self.showAlertWithAction(title: "Algo ha sucedido", message: requestError, closeButtonTitle: "Cerrar", extraAction: extraAction)
                // self.showAlert(message: requestError, closeButtonTitle: "Cerrar" )
            }).disposed(by: self.disposeBag)
    }
    
    private func getDate(stop: Stop) -> String {
        let date = stop.stopTime
        var calendar = Calendar.current
        
        if let timeZone = TimeZone(identifier: "Europe/London") {
            calendar.timeZone = timeZone
            calendar.locale = Locale(identifier: "en_US")
        }
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var hourValue = "\(hour)"
        if hour < 10 {
            hourValue = "0\(hour)"
        }
        
        var minuteValue = "\(minute)"
        if minute < 10 {
            minuteValue = "0\(minute)"
        }
        
        return "\(hourValue):\(minuteValue)"
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
        self.centerMapOnLocation(location: self.selectedMarker.position, zoom: self.mapZoom)
    }
    
    func clearMarkerInfo() {
        self.mapView.selectedMarker = nil
    }
}

extension GmapsController: GMSMapViewDelegate {
    // TODO: Try to add custom UIView to the infoWindow
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let markerId = marker.userData {
            marker.tracksInfoWindowChanges = true
            marker.title = self.loadingText
            marker.snippet = nil
            self.centerMapOnLocation(location: marker.position, zoom: self.mapZoom)
            self.mapView.selectedMarker = marker
            self.selectedMarker = marker
            self.viewModel?.getStopInfo(id: markerId as! Int)
        } else {
            self.showAlert(title: "", message: "No hay información disponible", closeButtonTitle: "Cerrar")
        }
        return true
    }
}
