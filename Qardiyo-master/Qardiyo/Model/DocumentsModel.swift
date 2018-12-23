//
//  DocumentsModel.swift
//  QardiyoHF_Patient
//
//  Created by Ravi on 15/07/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

struct DocumentsModel {
    var   patientPid : String = ""
    var  fileName : String = ""
    var remarks : String = ""
    var  fileurl : String = ""
    
    static func initialize(data:JSON)->DocumentsModel{
        var documentModel = DocumentsModel()
        //  let data = JSON(data["patient"])
        documentModel.patientPid = data["patient_pid"].stringValue
        documentModel.fileName = data["file_name"].stringValue
        documentModel.remarks = data["remarks"].stringValue
        documentModel.fileurl = data["file_url"].stringValue
        return documentModel
    }
    
    static func initializedModelList(listData:Array<Any>)->[DocumentsModel]{
        var documentModels = [DocumentsModel]()
        for tempData in listData{
            documentModels.append( initialize(data: JSON(tempData)))
        }
        return documentModels
    }
}
