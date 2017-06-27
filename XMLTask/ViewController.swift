//
//  ViewController.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

  @IBOutlet weak var backgroundTop: NSLayoutConstraint!
  @IBOutlet weak var background: UIImageView!
  @IBOutlet weak var tableView: UITableView!

  var onAir: OnAir!

  override func viewDidLoad() {
    super.viewDidLoad()

    let service = OnAirService()
    service.parse(xml: "/Users/bwl/.Desktop/jobs/XMLTask/XMLTask/onair.xml") {
      (result: OnAir?, error: OnAirServiceError?) in
      self.onAir = result

      self.tableView.reloadData()

      if let imageUrl = self.onAir.egpItem.customFields["image640"] {
        ImageService.retreiveImage(forUrl: imageUrl) { (image) in
          OperationQueue.main.addOperation {
            self.background.image = image
          }
        }
      }
    }

  }

  //MARK: UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return onAir?.playoutItems.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "playout") as! PlayoutItemCell
    cell.initWith(playoutItem: onAir.playoutItems[indexPath.row])
    return cell
  }

  //MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if (onAir == nil) {
      return nil
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
    cell.initWith(egpItem: onAir.egpItem)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return onAir != nil ? 90 : 0
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }

  //MARK: UIScrollViewDelegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = tableView.contentOffset.y
    if (offset > 0) { return }

    backgroundTop.constant = -20 - offset / 5.0
  }

}

