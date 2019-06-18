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
        var diag: CGFloat // height percent of image diagram
    }
    let arrayYears = [
        Year(year: 2012, diag: 8/18),
        Year(year: 2013, diag: 5/18),
        Year(year: 2014, diag: 17/18),
        Year(year: 2015, diag: 8/18),
        Year(year: 2016, diag: 14/18),
        Year(year: 2017, diag: 8/18),
        Year(year: 2018, diag: 11/18)
    ]

    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var middleCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

}

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if collectionView == middleCollectionView {
            guard let cellMiddle = cell as? MiddleCollectionViewCell else { return cell }
            let yearStat = arrayYears[indexPath.row]
            cellMiddle.yearLabel.text = yearStat.year.description

            cellMiddle.heightDiag.constant = cellMiddle.backgroundImageDiag.frame.size.height * yearStat.diag
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return 4
        } else if collectionView == middleCollectionView {
            return 7
        }

        return 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
