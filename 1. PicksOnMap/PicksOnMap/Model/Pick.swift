//
//  Pick.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/8/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase

class Pick: NSObject, MKAnnotation {
    let ref: DatabaseReference?
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.ref = nil
        self.title = name
        self.coordinate = coordinate

        super.init()
    }

    init?(with snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let latitude = value["latitude"] as? Double,
            let longitude = value["longitude"] as? Double else {
                return nil
        }

        self.ref = snapshot.ref
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func toAnyObject() -> Any {
        return [
            "title": title ?? "",
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
    }

}
