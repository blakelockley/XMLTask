//
//  EGPItem.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation

class EGPItem {

  let id: Int
  let name: String
  let description: String
  let time: Date
  let duration: String
  let presenter: String

  var customFields = [String: String]()

  init?(dict: [String : String]) {
    guard
    	let id = dict["id"].flatMap({ Int($0) }),
    	let name = dict["name"],
    	let description = dict["description"],
    	let time = dict["time"].flatMap(OnAirService.dateFormater.date),
    	let duration = dict["duration"],
      let presenter = dict["presenter"]
    else {
      return nil
    }

    self.id = id
    self.name = name
    self.description = description
    self.time = time
    self.duration = duration
    self.presenter = presenter
  }

  private func durationValue() -> Double {
    let cs = duration.components(separatedBy: ":")
    return Double(cs[0])! * 3600 + Double(cs[1])! * 60 + Double(cs[2])!
  }

  func prettyDuration() -> String {
    let cs = duration.components(separatedBy: ":").map({ Int($0)! })
    return (cs[0] > 0) ? "\(cs[0])" : "" + "\(cs[1]):\(cs[2])"
  }

  func progress() -> Double {
    let progress = Double(Date().timeIntervalSince(time))
    let ratio = progress / durationValue()

    return min(ratio, 1.0)
    
  }
  


}
