//
//  Tips.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-04-25.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation
import Alamofire

class Tips {

  private var _id: String!
  private var _title: String!
  private var _createdAt: String!
  
  var id: String {
    return _id
  }
  
  var title: String {
    return _title
  }
  
  var createdAt: String {
    return _createdAt
  }


  init(id: String, title: String, createdAt: String){
    self._id = id
    self._createdAt = createdAt
    self._title = title
  }
  

}
