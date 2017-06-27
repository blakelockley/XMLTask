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

  func initWith(egpItem: EGPItem) {
    name.text = egpItem.name
    information.text = egpItem.description
    time.text = egpItem.customFields["displayTime"]
  }

}
