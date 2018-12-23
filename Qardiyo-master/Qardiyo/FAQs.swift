//
//  FAQs.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-04-26.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation

class FAQs {

  private var _id: String!
  private var _question: String!
  private var _answer: String!
  private var _createdAt: String!
    var collapsed: Bool

  
  var id: String {
    return _id
  }
  
  var question: String {
    return _question
  }
  
  var answer: String {
    return _answer
  }
  
  var createdAt: String {
    return _createdAt
  }

  
    init(id: String, question: String, answer: String, createdAt: String, collapsed: Bool){
    self._id = id
    self._question = question
    self._answer = answer
    self._createdAt = createdAt
        self.collapsed = collapsed
  }

}
