//
//  PicksPresenter.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/10/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import MapKit

class PicksPresenter {
    var picks: [Pick] = []
    let ref = Database.database().reference(withPath: Auth.auth().currentUser?.uid ?? "0")
    var viewer: PicksViewer

    init(viewer: PicksViewer) {
        self.viewer = viewer

        ref.queryOrderedByKey().observe(.value) { snapshot in
            self.picks = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let pick = Pick(with: childSnapshot) {
                    self.picks.append(pick)
                }
            }

            self.viewer.updateData()
        }
    }

    func addNewPick(name: String, coordinate: CLLocationCoordinate2D) {
        let pick = Pick(name: name, coordinate: coordinate)

        let pickRef = ref.child(name)
        pickRef.setValue(pick.toAnyObject())

        viewer.updateData()
    }

    func deletePick(with index: Int) {
        let pick = picks[index]
        pick.ref?.removeValue()
    }

}

protocol PicksViewer {
    func updateData()
}
