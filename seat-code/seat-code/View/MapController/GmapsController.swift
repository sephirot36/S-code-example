//
//  GmapsController.swift
//  seat-code
//
//  Created by Daniel Castro on 05/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps

class GmapsController: UIViewController, MapControllerProtocol {
    // MARK: - @IBOutlets
    
    @IBOutlet var mapView: GMSMapView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
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
}

extension GmapsController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.title = "BLA BLA BLA"
        marker.snippet = "Population: 8,174,100"
        marker.tracksInfoWindowChanges = true
        mapView.selectedMarker=marker
        centerMapOnLocation(location: marker.position, zoom: 11)
        print("MARKER:\(String(describing: marker.userData))")
        return true
    }
}