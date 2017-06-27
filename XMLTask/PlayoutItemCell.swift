//
//  PlayoutItemCell.swift
//  XMLTask
//
//  Created by Blake Lockley on 27/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class PlayoutItemCell: UITableViewCell {
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var albumArt: UIImageView!
  @IBOutlet weak var trackName: UILabel!
  @IBOutlet weak var artistName: UILabel!
  @IBOutlet weak var timeLabel: UILabel!

  private(set) var playoutItem: PlayoutItem!
  private var imageService = ImageService()

  func initWith(playoutItem: PlayoutItem) {
    self.playoutItem = playoutItem

    trackName.text = playoutItem.title
    artistName.text = playoutItem.artist
    timeLabel?.text = playoutItem.prettyTime()

    activityIndicator.startAnimating()
    albumArt.isHidden = true

    imageService.retrieveImage(forUrl: playoutItem.imageUrl) { (image) in
      //ui updates should be on the main queue
      OperationQueue.main.addOperation {
        self.albumArt.isHidden = false
        self.albumArt.image = image
        self.activityIndicator.stopAnimating()
      }
    }

  }

}
