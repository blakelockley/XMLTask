//
//  PlayingCell.swift
//  XMLTask
//
//  Created by Blake Lockley on 27/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class PlayingCell: PlayoutItemCell {

  @IBOutlet weak var fullBar: UIView!
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var progressTrailing: NSLayoutConstraint!
  @IBOutlet weak var durationLabel: UILabel!

  override func initWith(playoutItem: PlayoutItem) {
    super.initWith(playoutItem: playoutItem)
    durationLabel.text = playoutItem.prettyDuration()
    updateProgress()
  }

  func updateProgress() {
    let progress = CGFloat(playoutItem.progress())
    let full = fullBar.frame.width - 2.0 //for borders

    progressTrailing.constant = full * (1 - progress) + 1

  }

}
