//
//  ImageService.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import UIKit

/*
 * Object to encapsulate retrieving images
 */
class ImageService: NSObject, URLSessionDelegate {

  private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
  private var dataTask: URLSessionDataTask!

  func retrieveImage(forUrl url: String, handler: @escaping (UIImage?) -> Void) {
    dataTask?.cancel()
    dataTask = defaultSession.dataTask(with: URL(string: url)!) {
      (data: Data?, urlResponse: URLResponse?, error: Error?) in
        let image = data.flatMap(UIImage.init)
        handler(image)
    }
    dataTask.resume()
  }
}
  
