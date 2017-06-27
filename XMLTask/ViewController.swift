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
  private let imageService = ImageService()

  private var header: HeaderCell!

  override func viewDidLoad() {
    super.viewDidLoad()
    retrieveData()

    //update progress bar every second
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      OperationQueue.main.addOperation { self.header?.updateProgress() }
    }

    //retreive new data according to predefinded interval
    Timer.scheduledTimer(withTimeInterval: reloadInterval, repeats: true) { _ in
      self.retrieveData()
    }
  }

  //retrieve new data, if it has changed make UI updates
  private func retrieveData() {
    service.onAirFrom(url: dataURL) {
      (result: OnAir?, error: OnAirServiceError?) in

      guard let newOnAir = result, error == nil else {
        //Error handing...
        let alert = UIAlertController(title: "Service Error", message: error!.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default) { _ in
          self.retrieveData()
          alert.dismiss(animated: true, completion: nil)
        })

        self.present(alert, animated: true, completion: nil)
        return
      }

      if self.onAir == nil ||
      	 newOnAir.egpItem.id != self.onAir.egpItem.id ||
        newOnAir.playingItem?.title != self.onAir.playingItem?.title
      {
        self.onAir = newOnAir
        OperationQueue.main.addOperation { self.tableView.reloadData() }

        guard let url = newOnAir.egpItem.customFields["image640"] else { return }
        self.imageService.retrieveImage(forUrl: url) { (image) in
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
    //creatse background slide effect
    let offset = tableView.contentOffset.y
    if (offset > 0) { return }
    
    backgroundTop.constant = -20 - offset / 5.0
  }
  
}
