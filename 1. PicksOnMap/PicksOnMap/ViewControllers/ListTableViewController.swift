//
//  ListTableViewController.swift
//  PicksOnMap
//
//  Created by BeerKoala on 6/10/19.
//  Copyright © 2019 a.kryvchykov. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController {

    var presenter: PicksPresenter!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = PicksPresenter(viewer: self)
        addLongPressGesturerecognizer(to: tableView)
        // Uncomment the following line to preserve selection between presentations
        //!!! self.clearsSelectionOnViewWillAppear = false
    }

}

extension ListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deletePick(with: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewControllers = tabBarController?.viewControllers else { return }
        for viewController in viewControllers {
            if let mapViewController = viewController as? MapViewController {
                mapViewController.currentPick = presenter.picks[indexPath.row]
                tabBarController?.selectedViewController = mapViewController
                break
            }
        }
    }
}

extension ListTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if presenter.picks.count > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Пока нет ни одной точки"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.picks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickCell", for: indexPath) as? PickTableViewCell ?? PickTableViewCell()
        let pick = presenter.picks[indexPath.row]
        cell.latitudeLabel.text = pick.coordinate.latitude.description
        cell.longitudeLabel.text = pick.coordinate.longitude.description
        cell.titleLabel.text = pick.title ?? ""

        return cell
    }
}

extension ListTableViewController: PicksViewer {
    func updateData() {
        tableView.reloadData()
    }
}

extension ListTableViewController: LongPressable {
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.ended {
            let touchPoint = gestureReconizer.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return } // long press on table view but not on a row

            UIAlertController.askToDo(in: self, title: "Удалить точку?") { [weak presenter, indexPath] in
                presenter?.deletePick(with: indexPath.row)
            }
        }
    }

}
