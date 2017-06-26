//
//  ViewController.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let service = OnAirService()
    service.parse(xml: "/Users/bwl/.Desktop/jobs/XMLTask/XMLTask/onair.xml") {
      (result: OnAir?, error: OnAirServiceError?) in

      for d in result!.playoutItems {
        print(d.title)
      }
    }

  }
}

