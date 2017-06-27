//
//  HeaderCell.swift
//  XMLTask
//
//  Created by Blake Lockley on 27/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var information: UILabel!
  @IBOutlet weak var time: UILabel!

  @IBOutlet weak var fullBar: UIView!
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var progressTrailing: NSLayoutConstraint!

  private(set) var item: EGPItem!

  func initWith(egpItem: EGPItem) {
    self.item = egpItem

    name.text = egpItem.name
    information.text = egpItem.description
    time.text = egpItem.customFields["displayTime"]

    updateProgress()
  }

  func updateProgress() {
    let progress = CGFloat(item.progress())
    let full = fullBar.frame.width - 2.0 //for borders

    progressTrailing.constant = full * (1 - progress) + 1
  }

}
