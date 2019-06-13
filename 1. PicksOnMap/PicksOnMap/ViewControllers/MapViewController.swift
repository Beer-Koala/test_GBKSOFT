//
//  MapViewController.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/8/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var presenter: PicksPresenter!
    var currentPick: Int?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = PicksPresenter(viewer: self)
        addLongPressGesturerecognizer(to: mapView)
        mapView.delegate = self

        locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()

        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

    }

    override func viewDidAppear(_ animated: Bool) {
        checkLocationAuthorizationStatus()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//        }
    }

    func checkLocationAuthorizationStatus() {
        mapView.showsUserLocation = true
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {

            //centerMap(on: mapView.userLocation.coordinate)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        currentPick = nil // must clear even if not loaded
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pick else { return nil }

        let reuseIdentifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)

        flagAnnotationView.canShowCallout = true

        // for clustering
        flagAnnotationView.clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier

        // Provide the annotation view's image.
        let image = #imageLiteral(resourceName: "Flag")
        flagAnnotationView.image = image

        // Offset the flag annotation so that the flag pole rests on the map coordinate.
        let offset = CGPoint(x: image.size.width / 2 - 8, y: -(image.size.height / 2) ) // 8 magic numbers
        flagAnnotationView.centerOffset = offset
        flagAnnotationView.calloutOffset = CGPoint(x: -13, y: 5)

        addTapGestureRecognizer(to: flagAnnotationView)

        return flagAnnotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = (view as? ClusterAnnotationView)?.annotation?.coordinate else { return }
        centerMap(on: coordinate)
    }

    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }
}

extension MapViewController: PicksViewer {
    func updateData() {
        mapView.removeAnnotations(mapView.annotations)
        for pick in presenter.picks {
            mapView.addAnnotation(pick)
        }

        if let currentPick = currentPick {
            guard presenter.picks.count > currentPick else { return }

            let pick = presenter.picks[currentPick]
            centerMap(on: pick.coordinate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.mapView.selectAnnotation(self.presenter.picks[currentPick], animated: true)
            }

            self.currentPick = nil
        }
    }

}

extension MapViewController: LongPressable {
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        //        if gestureReconizer.state != UIGestureRecognizer.State.ended { // i think no need to wait
        //            return
        //        }

        let touchPoint = gestureReconizer.location(in: mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)

        UIAlertController.showAlertWithTextField(in: self, title: "Введите название:", message: nil) { [weak self, coordinate] text in
            guard let strongSelf = self else { return }

            strongSelf.presenter.addNewPick(name: text, coordinate: coordinate)
        }
    }
}

extension MapViewController: Pressable {
    func handleTap(gestureReconizer: UITapGestureRecognizer) {
        if let annotation = (gestureReconizer.view as? MKAnnotationView)?.annotation,
            mapView.selectedAnnotations.contains(where: { $0 === annotation }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.mapView.deselectAnnotation(annotation, animated: true)
            }
        }
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentPick == nil,
            let coordinate = locations.first?.coordinate {
            centerMap(on: coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //requestLocation() // I think app dont need this
    }

//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if currentPick == nil {
//            centerMap(on: userLocation.coordinate)
//        }
//    }
}
