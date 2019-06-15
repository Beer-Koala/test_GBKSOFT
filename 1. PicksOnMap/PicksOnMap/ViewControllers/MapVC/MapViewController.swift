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

    enum NeedCenterState {
        case none
        case toPick(pick: Pick)
        case toCurrentLocation
    }

    enum NumberConstants: Double {
        case coordinateSpan = 0.1
        case asyncWait = 0.35
    }

    @IBOutlet weak var mapView: MKMapView!
    var presenter: PicksPresenter!
    var needCenter: NeedCenterState = .none
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = PicksPresenter(viewer: self)
        addLongPressGesturerecognizer(to: mapView)
        mapView.delegate = self

        locationManager.delegate = self

        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        if case .none = needCenter {
            needCenter = .toCurrentLocation
        }
        checkLocationAuthorizationStatus()
        centerIfNeeded()
    }

    func checkLocationAuthorizationStatus() {
        mapView.showsUserLocation = true
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // ok
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        needCenter = .none // must clear even if not loaded
    }

    func centerMap(on coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: NumberConstants.coordinateSpan.rawValue, longitudeDelta: NumberConstants.coordinateSpan.rawValue)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }

    func centerIfNeeded(currentLocation: CLLocationCoordinate2D? = nil) {
        switch needCenter {
        case .toPick(let pick):
            guard let pick = presenter.picks.first(where: { $0.title == pick.title }) else { return }

            centerMap(on: pick.coordinate)
            DispatchQueue.main.asyncAfter(deadline: .now() + NumberConstants.asyncWait.rawValue) {
                self.mapView.selectAnnotation(pick, animated: true)
            }

            self.needCenter = .none
        case .toCurrentLocation:
            if let currentLocation = currentLocation {
                centerMap(on: currentLocation)
                self.needCenter = .none
            }
        case .none: do {
            // nothing to do
            }
        }
    }
}

// MARK: PicksViewer
extension MapViewController: PicksViewer {
    func updateData() {
        mapView.removeAnnotations(mapView.annotations)
        presenter.picks.forEach {
            mapView.addAnnotation($0)
        }
        centerIfNeeded()
    }
}

// MARK: LongPressable
extension MapViewController: LongPressable {
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        //        if gestureReconizer.state != UIGestureRecognizer.State.ended { // I think no need to wait
        //            return
        //        }

        let touchPoint = gestureReconizer.location(in: mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)

        UIAlertController.showAlertWithTextField(in: self, message: nil) { [weak self, coordinate] text in
            guard let strongSelf = self else { return }

            strongSelf.presenter.addNewPick(name: text, coordinate: coordinate)
        }
    }
}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pick else { return nil }

        let reuseIdentifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)

        flagAnnotationView.canShowCallout = true
        flagAnnotationView.clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier // for clustering

        let image = #imageLiteral(resourceName: "Flag")
        flagAnnotationView.image = image

        // Offset the flag annotation so that the flag pole rests on the map coordinate.
        let offset = CGPoint(x: image.size.width / 2 - 8, y: -(image.size.height / 2) ) // magic numbers
        flagAnnotationView.centerOffset = offset
        flagAnnotationView.calloutOffset = CGPoint(x: -13, y: 5) // magic numbers

        addTapGestureRecognizer(to: flagAnnotationView)

        return flagAnnotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = (view as? ClusterAnnotationView)?.annotation?.coordinate {
            centerMap(on: coordinate)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        show(error: AppError.locationError)
        //requestLocation() // I think app dont need this
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerIfNeeded(currentLocation: userLocation.coordinate)
    }
}

// MARK: Pressable
extension MapViewController: Pressable {
    func handleTap(gestureReconizer: UITapGestureRecognizer) {
        if let annotation = (gestureReconizer.view as? MKAnnotationView)?.annotation,
            mapView.selectedAnnotations.contains(where: { $0 === annotation }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + NumberConstants.asyncWait.rawValue) {
                self.mapView.deselectAnnotation(annotation, animated: true)
            }
        }
    }
}

// MARK: ShowingAlert
extension MapViewController: ShowingAlert {
}
