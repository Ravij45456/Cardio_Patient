//
//  Questions.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-12-01.
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation

class Questions {
    
   private var _id: String
   private var _question: String
   private var _required: String
   private var _responseType: String
   private var _options: [Dictionary<String,Any>]
  
   var id: String {
    return _id
   }
  
   var question: String {
    return _question
   }
  
   var required: String {
    return _required
   }
  
   var responseType: String {
    return _responseType
   }
  
   var options: [Dictionary<String,Any>] {
     return _options
   }
    
    init(id: String, question: String, required: String, responseType: String, options: [Dictionary<String,Any>]?=nil) {
        self._id = id
        self._question = question
        self._required = required
        self._responseType = responseType
        self._options = options ?? []
    }
  
    
  
  
}
