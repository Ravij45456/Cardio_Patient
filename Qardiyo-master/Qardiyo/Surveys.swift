//
//  Surveys.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-05-10.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD


class Surveys {

  private var _survey_id: String!
  private var _assigned_at: String!
  private var _assigned_by: String!
  private var _completed_at: String!
  private var _title: String!
  private var _description: String!
  private var _questions: [Dictionary<String,Any>] = []
  
  private var _checkForSurveys: String!
  
  var survey_id: String {
    if _survey_id != nil {
      return _survey_id
    } else {
      return ""
    }
  }
  
  var assigned_at: String {
    if _assigned_at != nil {
      return _assigned_at
    } else {
      return ""
    }
  }
  
  var assigned_by: String{
    if _assigned_by != nil {
      return _assigned_by
    } else {
      return ""
    }
  }
  
  var completed_at: String{
    if _completed_at != nil {
      return _completed_at
    } else {
      return ""
    }
  }
  
  var title: String {
    if _title != nil {
      return _title
    } else {
      return ""
    }
  }
  
  var description: String {
    if _description != nil{
      return _description
    } else {
      return _description
    }
  }
  
  var questions: [Dictionary<String,Any>] {
    if !_questions.isEmpty {
     return _questions
    } else {
      return []
    }
  }
  
  var checkForSurveys: String {
    if _checkForSurveys != nil {
      return _checkForSurveys
    } else {
      return ""
    }
  }
  
  init(survey_id: String, assigned_at: String, assigned_by: String, completed_at: String, title: String, description: String, questions: [Dictionary<String,Any>]){
    self._survey_id = survey_id
    self._assigned_at = assigned_at
    self._assigned_by = assigned_by
    self._completed_at = completed_at
    self._title = title
    self._description = description
    self._questions = questions
  }
  
  init(survey_id: String, title: String, description: String, questions: [Dictionary<String,Any>]){
    self._survey_id = survey_id
    self._title = title
    self._description = description
    self._questions = questions
  }
  
  init(check: String){
    self._checkForSurveys = check
  }
  
  //GET ASSIGNED SURVEYS
  static func getAssignedSurveys(completed: @escaping (Surveys) -> Void){
      let dataUserDefault = UserDefaults.standard
      let token = dataUserDefault.value(forKey: "auth_token") as! String
      //let surveyURL = URL(string: "\(SURVEY_URL)auth_token=\(token!)")!
    
      let parameters: Parameters = [
         "auth_token": token
      ]
    
      //var questionsArray = [Questions]()
      var currentSurvey: Surveys!
      Alamofire.request("\(SURVEY_URL)", parameters: parameters).responseJSON { response in
            debugPrint(response)
          if let results = response.result.value as? Dictionary<String,[Dictionary<String,Any>]> {
            //get all surveys
            let surveys = results["surveys"]

            //iterate through surveys available
            for survey in surveys! {
              if let completionDate = survey["completed_at"] as? String {
                print("Survey was complete on \(completionDate)")
              } else {
                
                let id = survey["survey_id"] as! String
                let assignedAt = survey["assigned_at"] as! String
                let assignedBy = survey["assigned_by"] as! String
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let dateObj = dateFormatter.string(from: date)
                let completedAt = dateObj
                let title = survey["title"] as! String
                let description = survey["description"] as! String
                let questions = survey["questions"] as! [Dictionary<String,Any>]
                
                currentSurvey = Surveys(survey_id: id, assigned_at: assignedAt, assigned_by: assignedBy, completed_at: completedAt, title: title, description: description, questions: questions)
                
                break
              }
            }
            if currentSurvey == nil {
              currentSurvey = Surveys(check: "No")
            }
          }
          completed(currentSurvey)
      }
  }
   // static var count1:Int = 0
     static var firstStep = false
  
  //POST survey answers to openEMR
  static func submitSurveyAnswers(surveyCompleted: Int, answers: [Dictionary<String,Any>], completed: @escaping DownloadComplete){
    let dataUserDefault = UserDefaults.standard
    let token = dataUserDefault.value(forKey: "auth_token") as! String
    let surveyId = dataUserDefault.value(forKey: "SurveyId")
   
//    var firstStep = false
//    if count1 > 0 {
//        firstStep = true
//    }
//    count1 += 1
    
    
    let parameters: Parameters = [
      "auth_token": token,
      "survey_id": surveyId!,
      "answers": answers,
      ////////////  need to add new paramete
        
      "positive_count": surveyCompleted,// check the true count
        "assignby":8,// assign_By
        "is_second_step": false //first time false
    ]
    
    Alamofire.request("\(SUBMIT_SURVEY)", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
          debugPrint(response)
//        firstStep = firstStep
     completed()
    })
  }
  
    //GET ALL COMPLETED ASSIGNED SURVEYS
  static func getAllCompletedSurveys(completed: @escaping (String) -> Void){
    
      var arrayAnswers: String = ""
      let dataUserDefault = UserDefaults.standard
      let token = dataUserDefault.value(forKey: "auth_token") as! String
    
      let parameters: Parameters = [
         "auth_token": token
      ]
    
      //var questionsArray = [Questions]()
      Alamofire.request("\(GET_ALL_COMPLETED_SURVEYS)", parameters: parameters).responseJSON { response in
            debugPrint(response)
          if let results = response.result.value as? Dictionary<String,Any> {
            //get all surveys
            let completed_surveys = results["completed_surveys"] as! [Dictionary<String,Any>]
            
            for surveys in completed_surveys {
             if let question_answer = surveys["completed_survey_id"] as? String {
                arrayAnswers = question_answer
              }
            }
          }
          completed(arrayAnswers)
      }
  }
  
    //Get the answers of a completed survey
    static func getCompletedSurveys(completed_id: Int, completed: @escaping ([String]) -> Void){
    
      var arrayAnswers: [String] = []
      let dataUserDefault = UserDefaults.standard
      let token = dataUserDefault.value(forKey: "auth_token") as! String
    
      let parameters: Parameters = [
         "auth_token": token,
         "completed_survey_id": completed_id
      ] 
    
      //var questionsArray = [Questions]()
      Alamofire.request("\(GET_COMPLETED_SURVEY)", parameters: parameters).responseJSON { response in
            debugPrint(response)
          if let results = response.result.value as? Dictionary<String,Any> {
            //get all surveys
            let completed_survey = results["survey_answers"] as! Dictionary<String,Any>
            let questions = completed_survey["questions"] as! [Dictionary<String,Any>]
            
            for answers in questions {
             if let question_answer = answers["response"] as? String {
                arrayAnswers.append(question_answer)
              }
            }
          }
          completed(arrayAnswers)
      }
  }
  
  static func getExtraQuestions(completed: @escaping (Surveys) -> Void){
    let dataUserDefault = UserDefaults.standard
    let token = dataUserDefault.value(forKey: "auth_token") as! String
    
    let parameters: Parameters = [
      "auth_token": token
    ]
    
    var currentSurvey: Surveys!
    Alamofire.request("\(GET_EXTRA_QUESTIONS)", parameters: parameters).responseJSON { (response) in
        debugPrint(response)
        firstStep = true
        if let results = response.result.value as? Dictionary<String,Any> {
          let theSurvey = results["survey"] as! Dictionary<String,Any>
          let surveyId = theSurvey["id"] as! String
          let surveyTitle = theSurvey["title"] as? String ?? NSUUID().uuidString
          let surveyDescription = theSurvey["description"] as! String
          let surveyQuestions = theSurvey["questions"] as! [Dictionary<String,Any>]
          
          currentSurvey = Surveys(survey_id: surveyId, title: surveyTitle, description: surveyDescription, questions: surveyQuestions)
            
            
        }
      
        completed(currentSurvey)
    }
  }
}
