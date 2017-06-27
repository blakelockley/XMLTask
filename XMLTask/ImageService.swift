//
//  ImageService.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

class ImageService: NSObject, URLSessionDelegate {

  static private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

  class func retreiveImage(forUrl url: String, handler: @escaping (UIImage?) -> Void) {
    defaultSession.dataTask(with: URL(string: url)!) {
      (data: Data?, urlResponse: URLResponse?, error: Error?) in
        let image = data.flatMap(UIImage.init)
        handler(image)
    }.resume()
  }
}
  
