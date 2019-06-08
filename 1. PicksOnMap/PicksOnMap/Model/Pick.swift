//
//  Pick.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/8/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation
import MapKit

class Pick: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.title = name
        self.coordinate = coordinate

        super.init()
    }
}
