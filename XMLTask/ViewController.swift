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

  private var onAir: OnAir!
  private let service = OnAirService()

  private var header: HeaderCell!

  override func viewDidLoad() {
    super.viewDidLoad()
    retreiveData()

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      OperationQueue.main.addOperation { self.header?.updateProgress() }
    }

    Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
      self.retreiveData()
      print(self.onAir.playoutItems.first?.title ?? "none")
    }
  }

  private func retreiveData() {
    service.onAirFrom(url: "http://aim.appdata.abc.net.au.edgesuite.net/data/abc/triplej/onair.xml") {
      (result: OnAir?, error: OnAirServiceError?) in

      guard let newOnAir = result, error == nil else {
        print(error!)
        return
      }

      if self.onAir == nil ||
      	 newOnAir.egpItem.id != self.onAir.egpItem.id ||
        newOnAir.playingItem?.title != self.onAir.playingItem?.title
      {
        self.onAir = newOnAir
        OperationQueue.main.addOperation { self.tableView.reloadData() }

        guard let url = newOnAir.egpItem.customFields["image640"] else { return }
        ImageService.retreiveImage(forUrl: url.substring(from: url.index(url.startIndex, offsetBy: 1))) { (image) in
          OperationQueue.main.addOperation { self.background.image = image }
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
    let playout = onAir.playoutItems[indexPath.row]

    let cell: PlayoutItemCell

    if (playout.status == .playing) {
      cell = tableView.dequeueReusableCell(withIdentifier: "playing") as! PlayingCell
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: "playout") as! PlayoutItemCell
    }

    cell.initWith(playoutItem: playout)

    return cell
  }

  //MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if (onAir == nil) {
      return nil
    }

    if header == nil {
      header = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
    }

    header.initWith(egpItem: onAir.egpItem)
    return header.contentView
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

