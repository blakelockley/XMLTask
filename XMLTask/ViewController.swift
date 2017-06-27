//
//  ViewController.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var onAir: OnAir!
  var i = -1

  @IBOutlet weak var picture: UIImageView!

  func tapped(_ sender: Any) {
    i = (i + 1) % onAir.playoutItems.count
    onAir.playoutItems[i].retreiveImage() { (image) in
      OperationQueue.main.addOperation {
        self.picture.image = image
      }
    }
    print(i)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
    picture.addGestureRecognizer(tap)

    picture.isHidden = true
    let service = OnAirService()
    service.parse(xml: "/Users/bwl/.Desktop/jobs/XMLTask/XMLTask/onair.xml") {
      (result: OnAir?, error: OnAirServiceError?) in
      self.onAir = result
      self.picture.isHidden = false
      self.tapped(self)
    }
  }
}

