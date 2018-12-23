//
//  Answers.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-05-11.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation

class Answers {

  private var _question_id: String!
  private var _answer: String!
  
  var question_id: String {
    return _question_id
  }
  
  var answer: String {
    return _answer
  }

  init(question_id: String, answer: String){
    self._question_id = question_id
    self._answer = answer
  }


}
