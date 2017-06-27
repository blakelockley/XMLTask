//
//  PlayoutItem.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

enum PlayoutItemStatus: String {
  case playing, history
}

enum PlayoutItemType: String {
  case song
}

class PlayoutItem {

  let time: Date
  let duration: String
  let title: String
  let artist: String
  let imageUrl: String

  let status: PlayoutItemStatus
  let type: PlayoutItemType

  var customFields = [String: String]()

  private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "h:mma"
    return df
  }()

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

  func prettyTime() -> String {
    return dateFormatter.string(from: time)
  }

  //removes hours if they are zero
  func prettyDuration() -> String {
    let cs = duration.components(separatedBy: ":").map({ Int($0)! })
    return (cs[0] > 0) ? "\(cs[0])" : "" + "\(cs[1]):\(cs[2])"
  }

}
