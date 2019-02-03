//
//  PatientModel.swift
//  QardiyoHF_Patient
//
//  Created by Ashish kumar patel on 28/06/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

struct PatientModel {
    
        var  id : String = "0"
    var  title : String = "0"
    var  firstName : String = "0"
    var  lastLame : String = "0"
     var dob : String = "0"
     var ssn : String = "0"
     var email : String = "0"
     var pubpid : String = "0"
     var pid : String = "0"
     var reveviedPoints : String = "0"
     var unreadMsgCount : String = "0"
     var quickBloxId : String = "0"
    
   
    
    static func initialize(data:JSON)->PatientModel{
        var patientModel = PatientModel()
      let data = JSON(data["patient"])
        patientModel.id = data["id"].stringValue
        patientModel.title = data["title"].stringValue
        patientModel.firstName = data["first_name"].stringValue
        patientModel.lastLame = data["last_name"].stringValue
        patientModel.dob = data["dob"].stringValue
        patientModel.ssn = data["ssn"].stringValue
        patientModel.email = data["email"].stringValue
        patientModel.pubpid = data["pubpid"].stringValue
         patientModel.pid = data["pid"].stringValue
         patientModel.reveviedPoints = data["revevied_points"].stringValue
         patientModel.unreadMsgCount = data["unread_msg_count"].stringValue
         patientModel.quickBloxId = data["quick_blox_id"].stringValue
        
        return patientModel
    }
    
    static func initializedPatientModelList(listData:Array<Any>)->[PatientModel]{
        var StatusLogs = [PatientModel]()
        for tempData in listData{
            StatusLogs.append( initialize(data: JSON(tempData)))
        }
        return StatusLogs
    }
}
