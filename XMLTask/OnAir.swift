//
//  OnAir.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation

class OnAir {
  let egpItem: EGPItem
  let playoutItems: [PlayoutItem]

  init(egpItem: EGPItem, playoutItems: [PlayoutItem]) {
    self.egpItem = egpItem
    self.playoutItems = playoutItems
  }

}
