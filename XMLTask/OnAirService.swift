//
//  OnAirService.swift
//  XMLTask
//
//  Created by Blake Lockley on 26/06/2017.
//  Copyright © 2017 Blake Lockley. All rights reserved.
//

import Foundation

enum OnAirServiceError: Error {
  case parsingError(element: String)
  case alreadyParsingError
}

/*
 * Object to encapsulate parsing the XML data to an OnAir object
 * The primary method of this class is "onAirFrom(xml:_:) which provides
 * a callback containg an error or completed OnAir object
 */
class OnAirService: NSObject, XMLParserDelegate {

  static let dateFormater: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
    return df
  }()

  private enum ElementName: String {
    case onAir, epgData, epgItem, customFields, customField
    case playoutData, playoutItem
  }

  private var parser: XMLParser!
  private var handler: ((OnAir?, OnAirServiceError?) -> Void)!
  private var egpItem: EGPItem!
  private var currentPlayoutItem: PlayoutItem!
  private var playoutItems: [PlayoutItem]!
  private var parsingEGPFields = false
  private(set) var parsing: Bool = false

  func parse(xml: String, handler: @escaping ((OnAir?, OnAirServiceError?) -> Void)) {
    if parsing {
      handler(nil, OnAirServiceError.alreadyParsingError)
    }

    self.handler = handler

    parser = XMLParser(contentsOf: URL(fileURLWithPath: xml))
    parser?.delegate = self
    parser?.parse()

  }

  private func finish(withError error: OnAirServiceError? = nil) {
    switch error {
    case nil:
      handler(OnAir(egpItem: egpItem, playoutItems: playoutItems), nil)
    default:
      handler(nil, error)
    }

    if parsing {
      parser.abortParsing()
      parsing = false
    }

    handler = nil
    egpItem = nil
    currentPlayoutItem = nil
    playoutItems = nil
  }

  //MARK: XMLParserDelegate

  func parserDidStartDocument(_ parser: XMLParser) {
    parsing = true
  }

  func parserDidEndDocument(_ parser: XMLParser) {
    parsing = false
    finish()
  }

  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

    guard let element = ElementName(rawValue: elementName) else {
      finish(withError: .parsingError(element: elementName))
      return
    }

    switch element {
    case .epgItem:
      if let epg = EGPItem(dict: attributeDict) {
        egpItem = epg
      } else {
        finish(withError: .parsingError(element: elementName))
      }
      parsingEGPFields = true

    case .playoutData:
      playoutItems = [PlayoutItem]()

    case .playoutItem:
      if let playout = PlayoutItem(dict: attributeDict) {
        currentPlayoutItem = playout
      } else {
        finish(withError: .parsingError(element: elementName))
      }

    case .customField:
      if let name = attributeDict["name"], let value = attributeDict["value"] {
        if parsingEGPFields {
          egpItem.customFields[name] = value
        } else {
          currentPlayoutItem.customFields[name] = value
        }
      }

    default: break
    }
  }

  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

    guard let element = ElementName(rawValue: elementName) else {
      finish(withError: .parsingError(element: elementName))
      return
    }

    switch element {
    case .epgItem:
      parsingEGPFields = false

    case .playoutItem:
      playoutItems.append(currentPlayoutItem)

    default: break
    }
  }
}
