//
//  PatientCharDataModel.swift
//  QardiyoHF_Patient
//
//  Created by Ashish kumar patel on 21/08/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

//class PatientCharDataModel: NSObject {
//
//}

struct CharData {
    
    var avgBPDiastolic: String = ""
    var avgBPSystolic: String = ""
    var avgSteps: String = ""
    var avgHeartRate: String = ""
   var avgHeight: String = ""
    var avgWeight: String = ""
    var avgSleepMinutes: String  = ""
    var date: String  = ""
    var hour : String = ""
    var month: String  = ""
    var monthNo: String  = ""
    var day : String = ""

    
    static func initialize(data:JSON)->CharData{
        var chartData = CharData()
               //let data = JSON(data["month_data"])
   
        chartData.avgBPDiastolic = data["avg_bp_diastolic"].stringValue
        chartData.avgBPSystolic = data["avg_bp_systolic"].stringValue
        
                chartData.avgSteps = data["avg_steps"].stringValue
                chartData.avgHeartRate = data["avg_heart_rate"].stringValue
                chartData.avgHeight = data["avg_height"].stringValue
                chartData.avgWeight = data["avg_weight"].stringValue
            chartData.avgSleepMinutes = data["avg_sleep_minutes"].stringValue
            chartData.date = data["date"].stringValue
         chartData.hour = data["hour"].stringValue
        chartData.month = data["month"].stringValue
        chartData.monthNo = data["month_no"].stringValue
        chartData.day = data["day"].stringValue

        

      
        return chartData
    }
    
    static func initializedModelList(listData:Array<Any>)->[CharData]{
        var chartModels = [CharData]()
        for tempData in listData{
            chartModels.append( initialize(data: JSON(tempData)))
        }
        return chartModels
    }
}



struct PatientCharDataModel {
    var yearlyChartData =  [CharData()]
      var monthlyChartData =  [CharData()]
       var weeklyChartData =  [CharData()]
       var dailyChartData =  [CharData()]
    
     var yearAvarageData = CharData()
    var monthAvarageData = CharData()
      var weekAvarageData = CharData()
     var dailyAvarageData = CharData()
    
    
    static func initialize(data:JSON)->PatientCharDataModel{
        var patientChartModel = PatientCharDataModel()
        patientChartModel.yearlyChartData = CharData.initializedModelList(listData: data["yearly"]["data"].arrayObject!)
         patientChartModel.monthlyChartData = CharData.initializedModelList(listData: data["monthly"]["data"].arrayObject!)
           patientChartModel.weeklyChartData = CharData.initializedModelList(listData: data["weekly"]["data"].arrayObject!)
           patientChartModel.dailyChartData = CharData.initializedModelList(listData: data["daily"]["data"].arrayObject!)
        
         patientChartModel.yearAvarageData = CharData.initialize(data: data["yearly"]["avg"])
         patientChartModel.monthAvarageData = CharData.initialize(data: data["monthly"]["avg"])
         patientChartModel.weekAvarageData = CharData.initialize(data: data["weekly"]["avg"])
         patientChartModel.dailyAvarageData = CharData.initialize(data: data["daily"]["avg"])
        
        //   patientChartModel.yearlyChartData = CharData.initializedModelList(listData: data["yearly"].arrayObject!)
        
        return patientChartModel
    }
}
