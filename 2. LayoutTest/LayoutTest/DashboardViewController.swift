//
//  DashboardViewController.swift
//  LayoutTest
//
//  Created by BeerKoala on 6/18/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    struct Year {
        var year: Int
        var diag: String // name of image
    }
    //let arrayYears = [Year(year: 2012, diag: <#T##String#>)]

    @IBOutlet weak var topCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

}

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTop", for: indexPath)

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
