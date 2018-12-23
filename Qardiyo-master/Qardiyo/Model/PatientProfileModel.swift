//
//  PatientProfileModel.swift
//  QardiyoHF_Patient
//
//  Created by Ravi on 15/07/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//


import UIKit
import SwiftyJSON

struct PatientProfileModel {
    var   patientId : String = ""
    var  allergies : String = ""
    var familyDoctor : String = ""
    var  emergencyNo : String = ""
    
    static func initialize(data:JSON)->PatientProfileModel{
        var patientProfileModel = PatientProfileModel()
        //  let data = JSON(data["patient"])
        patientProfileModel.patientId = data["patient_id"].stringValue
        patientProfileModel.allergies = data["allergies"].stringValue
        patientProfileModel.familyDoctor = data["family_doctor"].stringValue
        patientProfileModel.emergencyNo = data["emergency_no"].stringValue
        return patientProfileModel
    }
}
