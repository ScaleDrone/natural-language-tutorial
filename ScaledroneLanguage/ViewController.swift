//
//  ViewController.swift
//  ScaledroneLanguage
//
//  Created by Marin Benčević on 09/01/2019.
//  Copyright © 2019 Scaledrone. All rights reserved.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {

  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var entityLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  let languageRecognizer = NLLanguageRecognizer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    languageLabel.text = ""
    entityLabel.text = ""
    textField.addTarget(self, action: #selector(onTextFieldChanged), for: .editingChanged)
  }
  
  func recognizeLanguage(_ text: String)-> NLLanguage? {
    languageRecognizer.reset()
    languageRecognizer.processString(text)
    return languageRecognizer.dominantLanguage
  }
  
  func recognizeTags(_ text: String) -> [(String, NLTag)] {
    let tags: [NLTag] = [.personalName, .placeName, .organizationName]
    let tagger = NLTagger(tagSchemes: [.nameType])
    tagger.string = text
    
    var results: [(String, NLTag)] = []
    tagger.enumerateTags(
      in: text.startIndex..<text.endIndex,
      unit: .word,
      scheme: .nameType,
      options: [.omitWhitespace, .omitPunctuation, .joinNames],
      using: { tag, range in
        guard let tag = tag, tags.contains(tag) else {
          return true
        }
        
        print("Found tag \(tag) in text \"\(text[range])\"")
        results.append((String(text[range]), tag))
        return true
    })
    return results
  }
  
  @objc func onTextFieldChanged(_ textField: UITextField) {
    guard let text = textField.text else {
      return
    }
    
    if let language = recognizeLanguage(text) {
      let name = language.rawValue
      languageLabel.text = name
    }
    
    let results = recognizeTags(text)

    let entityText = results
      .map { (word, tag) in
        "\(word) (\(tag.rawValue))"
      }
      .joined(separator: ", ")

      entityLabel.text = entityText
  }
}

