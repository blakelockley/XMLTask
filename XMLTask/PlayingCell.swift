//
//  PlayingCell.swift
//  XMLTask
//
//  Created by Blake Lockley on 27/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class PlayingCell: PlayoutItemCell {

  @IBOutlet weak var durationLabel: UILabel!

  override func initWith(playoutItem: PlayoutItem) {
    super.initWith(playoutItem: playoutItem)
    durationLabel.text = playoutItem.prettyDuration()
  }

}
