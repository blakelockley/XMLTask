//
//  PlayoutItem.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

enum PlayoutItemStatus: String {
  case history
}

enum PlayoutItemType: String {
  case song
}

class PlayoutItem {

  let time: Date
  let duration: String
  let title: String
  let artist: String

  let status: PlayoutItemStatus
  let type: PlayoutItemType

  var customFields = [String: String]()

  private let imageUrl: String
  //private(set) var image: UIImage?

  init?(dict: [String: String]) {
    guard
    	let time = dict["time"].flatMap(OnAirService.dateFormater.date),
      let duration = dict["duration"],
    	let title = dict["title"],
      let artist = dict["artist"],
    	let status = dict["status"].flatMap(PlayoutItemStatus.init),
      let type = dict["type"].flatMap(PlayoutItemType.init),
      let imageUrl = dict["imageUrl"]
    else {
      return nil
    }

    self.time = time
    self.duration = duration
    self.title = title
    self.artist = artist
    self.status = status
    self.type = type
    self.imageUrl = imageUrl
  }

  func retreiveImage(handler: @escaping (UIImage?) -> Void) {
    ImageService.retreiveImage(forUrl: imageUrl) { (image) in
      //self.image = image
      handler(image)
    }
  }


}
