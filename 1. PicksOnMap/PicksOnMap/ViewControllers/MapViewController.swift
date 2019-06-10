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
    //let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = PicksPresenter(viewer: self)
        addLongPressGesturerecognizer(to: mapView)
        mapView.delegate = self

        //locationManager.requestWhenInUseAuthorization()

    }

    override func viewDidAppear(_ animated: Bool) {
        //checkLocationAuthorizationStatus()

        if let currentPick = currentPick {
            mapView.selectAnnotation(presenter.picks[currentPick], animated: true)
        }
    }

//    func checkLocationAuthorizationStatus() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }

    override func viewDidDisappear(_ animated: Bool) {
        currentPick = nil
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pick else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            //view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        addTapGestureRecognizer(to: view)
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if mapView.selectedAnnotations.contains(where: { $0 === view.annotation }) {
//            mapView.deselectAnnotation(view.annotation, animated: true)
//        }
    }
}

extension MapViewController: PicksViewer {
    func updateData() {
        mapView.removeAnnotations(mapView.annotations)
        for pick in presenter.picks {
            mapView.addAnnotation(pick)
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

            //            let touchPoint = gestureReconizer.location(in: strongSelf.mapView)
            //            let coordinate = strongSelf.mapView.convert(touchPoint, toCoordinateFrom: strongSelf.mapView)

            strongSelf.presenter.addNewPick(name: text, coordinate: coordinate)
        }
    }
}

extension MapViewController: Pressable {
    func handleTap(gestureReconizer: UITapGestureRecognizer) {
        if let annotation = (gestureReconizer.view as? MKAnnotationView)?.annotation,
            mapView.annotations.contains(where: { $0 === annotation }) {
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }

}
