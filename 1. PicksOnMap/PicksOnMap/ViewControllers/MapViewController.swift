//
//  MapViewController.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/8/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        //longPressRecognizer.delaysTouchesBegan = true //!!!
        mapView.addGestureRecognizer(longPressRecognizer)

        mapView.delegate = self

        //locationManager.requestWhenInUseAuthorization()

    }

//    override func viewDidAppear(_ animated: Bool) {
//        checkLocationAuthorizationStatus()
//    }

//    func checkLocationAuthorizationStatus() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
//        if gestureReconizer.state != UIGestureRecognizer.State.ended { // i think no need to wait
//            return
//        }

        let touchPoint = gestureReconizer.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)

        UIAlertController.showAlertWithTextField(in: self, title: "Введите название:", message: nil) { [weak self, coordinate] text in
            guard let strongSelf = self else { return }

//            let touchPoint = gestureReconizer.location(in: strongSelf.mapView)
//            let coordinate = strongSelf.mapView.convert(touchPoint, toCoordinateFrom: strongSelf.mapView)

            let pick = Pick(name: text, coordinate: coordinate)

            strongSelf.mapView.addAnnotation(pick)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Pick else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //view.cluster
        }
        return view
    }
}
