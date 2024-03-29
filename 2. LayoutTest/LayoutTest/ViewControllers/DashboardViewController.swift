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

    struct Day {
        var date: String
        var sum: String
    }
    let arrayMonth = [
        Day(date: "January 01", sum: "$2,029"),
        Day(date: "January 02", sum: "$1,2"),
        Day(date: "January 03", sum: "$1,1"),
        Day(date: "January 04", sum: "$5,111"),
        Day(date: "January 05", sum: "$2,1"),
        Day(date: "January 06", sum: "$2,1")
//        Day(date: "January 07", sum: "$1,2"),
//        Day(date: "January 08", sum: "$1,1")
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

extension DashboardViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMonth.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let cellBottom = cell as? BottomTableViewCell else { return cell }

        cellBottom.topLeftLine.isHidden = false
        cellBottom.bottomLeftLine.isHidden = false
        if indexPath.row == 0 {
            cellBottom.topLeftLine.isHidden = true
        }
        if indexPath.row == arrayMonth.count - 1 {
            cellBottom.bottomLeftLine.isHidden = true
        }

        cellBottom.dateLabel.text = arrayMonth[indexPath.row].date
        cellBottom.sumLabel.text = arrayMonth[indexPath.row].sum

        return cellBottom
    }

}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
}
