//
//  MapControllerProtocol.swift
//  seat-code
//
//  Created by Daniel Castro on 05/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import GoogleMaps

protocol MapControllerProtocol {
    func clearMap()
    
    func centerMapOnLocation(location: CLLocationCoordinate2D, zoom: Float)
    
    func centerMapBetweenPoints(origin: CLLocationCoordinate2D, end: CLLocationCoordinate2D)
    
    func createMarkerAtLocation(location: CLLocationCoordinate2D, icon: UIImage?)
    
    func createMarkerAtLocationWithId(location: CLLocationCoordinate2D, icon: UIImage?, id: Int)
    
    func drawLine(points: [CLLocationCoordinate2D])
}

