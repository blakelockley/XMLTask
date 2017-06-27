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
  @IBOutlet weak var durationLabel: UILabel!

  func initWith(playoutItem: PlayoutItem) {
    trackName.text = playoutItem.title
    artistName.text = playoutItem.artist
    durationLabel.text = playoutItem.duration

    activityIndicator.startAnimating()
    albumArt.isHidden = true

    //Theres a very inconspicuous bug here: images from previously used cells may pop up if the image handler takes
    //to long to complete (this will be fixed in a seperate commit)
    playoutItem.retreiveImage { (image) in
      //ui updates should be on the main queue
      OperationQueue.main.addOperation {
        self.albumArt.isHidden = false
        self.albumArt.image = image
        self.activityIndicator.stopAnimating()
      }
    }

  }

}
