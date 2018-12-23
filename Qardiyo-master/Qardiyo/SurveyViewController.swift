//
//  SurveyViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-25.
//  Edited by Jorge Gomez.
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire
import ResearchKit
import SVProgressHUD


class SurveyViewController: UIViewController, ORKTaskViewControllerDelegate {
  
    var extraSteps: [ORKStep] = []
    var surveyTitle: String!
    let greenColor = UIColor(red: 123/255, green: 171/255, blue: 56/255, alpha: 1.0)
    let blueColor = UIColor(red: 25/255, green: 62/255, blue: 78/255, alpha: 1.0)

    var firstSurveyAnswers = [Dictionary<String,Any>]()
    
    var newObjectAnswers = [Dictionary<String,Any>]()
    
    var firstSurveyQuestions = [Questions]()
    var answers = [String]()
    var answersText = [String]()

    var answersTextFirstSurvey = [String]()

    var questions = [Questions]()
    var newQuestions = [Questions]()
    var survey_id: String!
  
    var parentVC:UIViewController!
    
    var btnAllDone = UIButton()
    
    var fistLoad = true
    
    override func viewDidLoad() {
//        view.backgroundColor = UIColor.clear
//        view.isOpaque = false

      print(extraSteps)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        btnAllDone.frame = CGRect(x:(screenWidth - 200) / 2, y: screenHeight - 90, width: 200, height: 40)
        btnAllDone.setTitle("All Done", for: .normal)
        btnAllDone.tag = 999
        btnAllDone.layer.cornerRadius = 5
        btnAllDone.backgroundColor = greenColor
        btnAllDone.addTarget(self, action: #selector(touchOnAllDone), for: .touchUpInside)
        
        print("test 1")
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        print("test 2")
        if fistLoad == true {
            print("test 3")
            let task1 = ORKOrderedTask(identifier: "\(surveyTitle)", steps: self.extraSteps)
            print("test 4")
            let extraTaskViewController = ORKTaskViewController(task: task1, taskRun: nil)

            extraTaskViewController.delegate = self
            extraTaskViewController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            
            extraTaskViewController.navigationBar.barTintColor = self.greenColor

            present(extraTaskViewController, animated: true, completion: nil)
            print("test 5")
        }
        fistLoad = false
    }
  
    func touchOnAllDone(){
        if let vc = self.presentedViewController{
            vc.dismiss(animated: true, completion: {
                self.dismiss(animated: false, completion: {
                    complete in
//                    SVProgressHUD.show()
//                    let yesArray =  self.answersText.filter{$0 == "Yes" || $0 == "yes" || $0 == "YES" }
//                    Surveys.submitSurveyAnswers(surveyCompleted: yesArray.count, answers: self.newObjectAnswers, completed: {
//                        SVProgressHUD.dismiss()
//                        Surveys.getAllCompletedSurveys(completed: { (completed_id) in
//                            SVProgressHUD.dismiss()
//                        })
                 //   })
                })
            })
        }   }
   
        
    
    func showAnswerVC(viewController:UIViewController){
        var answerObject = [Dictionary<String,Any>]()
        
        answerObject.removeAll()
        
        for i in 0 ... self.questions.count-1{
            let questionId = self.questions[i].id.int
            var realAnswer = ""
            if(self.answers[i] == "1"){
                realAnswer = "Yes"
            } else if self.answers[i] == "0" {
                realAnswer = "No"
            } else {
                let temp = self.answers[i].replacing("(\n    ", with: "")
                let temp2 = temp.replacing(")", with: "")
                let temp3 = temp2.replacing("\n", with: "")
                realAnswer = temp3
            }
            answerObject.append([
                "question_id": questionId!,
                "answer": realAnswer
                ])
        }
        self.newObjectAnswers = answerObject + self.firstSurveyAnswers
        self.newQuestions = self.questions + self.firstSurveyQuestions
        
        
        //PRESNT ANSWERS IN TABLE VIEW
        let resultController = self.storyboard?.instantiateViewController(withIdentifier: "SurveyResults") as! SurveyResultsVC
        resultController.questions = self.newQuestions
        resultController.answersSurvey2 = self.newObjectAnswers
        resultController.answersTextSurvey2 = self.answersText
        resultController.answersTextSurvey1 = self.answersTextFirstSurvey
        resultController.extraAnswers = true
        resultController.survey_id = self.survey_id
        viewController.present(resultController, animated: true, completion: nil)
    }
    
    public func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        stepViewController.cancelButtonItem?.tintColor = blueColor

        var foundButton = false
        for view in taskViewController.view.subviews{
            if view.tag == 999{
                foundButton = true
                btnAllDone.isHidden = true
            }
        }
        
        if taskViewController.currentStepViewController?.step is ORKCompletionStep {
            if let results = taskViewController.result.results as? [ORKStepResult] {
                for stepResult: ORKStepResult in results {
                    for result in ([ORKResult]?(stepResult.results!))!{
                        if let questionResult = result as? ORKQuestionResult {
                            answers.append("\(questionResult.answer!)")
                            
                            for question in self.questions{
                                if question.id == result.identifier {
                                    //                                    print("Question: \(question.question)")
                                    
                                    let quesAns = "\(questionResult.answer!)"
                                    
                                    if(quesAns == "1"){
                                        answersText.append("Yes")
                                    } else  if(quesAns == "0"){
                                        answersText.append("No")
                                    } else if question.options.count <= 0 {
                                        answersText.append("\(questionResult.answer!)")
                                    } else{
                                        
                                        for opt in question.options {
                                            //                                            print("Option: \(opt)")
                                            
                                            let optID = opt["id"] as! String
                                            var answerID = "\(questionResult.answer!)"
                                            
                                            let temp = answerID.replacing("(\n    ", with: "")
                                            let temp2 = temp.replacing(")", with: "")
                                            let temp3 = temp2.replacing("\n", with: "")
                                            answerID = temp3
                                            
                                            if optID.trimmed == answerID {
                                                answersText.append(opt["name"] as! String)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            self.showAnswerVC(viewController: taskViewController)
            
            if foundButton == false {
                taskViewController.view.addSubview(btnAllDone)
            }else{
                btnAllDone.isHidden = false
            }
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
      
      if (reason.rawValue == 2){
      
          if let results = taskViewController.result.results as? [ORKStepResult] {
              for stepResult: ORKStepResult in results {
                  for result in ([ORKResult]?(stepResult.results!))!{
                      if let questionResult = result as? ORKQuestionResult {
                          answers.append("\(questionResult.answer!)")
                      }
                  }
              }
          }
          
//          var answerObject = [Dictionary<String,Any>]()
//
//          for i in 0 ... questions.count-1{
//            let questionId = questions[i].id.int
//            var realAnswer = ""
//            if(answers[i] == "1"){
//              realAnswer = "Yes"
//            } else if answers[i] == "0" {
//              realAnswer = "No"
//            } else {
//              let temp = answers[i].replacing("(\n    ", with: "")
//              let temp2 = temp.replacing(")", with: "")
//              let temp3 = temp2.replacing("\n", with: "")
//              realAnswer = temp3
//
//            }
//            answerObject.append([
//                  "question_id": questionId!,
//                  "answer": realAnswer
//            ])
//          }
//
//          newObjectAnswers = answerObject + firstSurveyAnswers
//          newQuestions = questions + firstSurveyQuestions
////
////
////        // GET ALL ANSWERS STORE THEM
////        //DISPLAY THEM IN SURVEYRESULTVC
//        let resultController = self.storyboard?.instantiateViewController(withIdentifier: "SurveyResults") as! SurveyResultsVC
//          resultController.questions = newQuestions
//          resultController.answersSurvey2 = newObjectAnswers
//          resultController.extraAnswers = true
//          resultController.survey_id = survey_id
//          taskViewController.present(resultController, animated: true, completion: nil)
          //  touchOnAllDone()
        let surveyResultController = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
        taskViewController.present(surveyResultController, animated: true, completion: nil)
      } else {
        let surveyResultController = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
        taskViewController.present(surveyResultController, animated: true, completion: nil)
      }

    }
    
//    func taskViewControllerShouldConfirmCancel(_ taskViewController: ORKTaskViewController) -> Bool {
//        SVProgressHUD.show()
//        Surveys.submitSurveyAnswers(surveyCompleted: 0, answers: self.newObjectAnswers, completed: {
//            SVProgressHUD.dismiss()
//            //                        Surveys.getAllCompletedSurveys(completed: { (completed_id) in
//            //                            SVProgressHUD.dismiss()
//            //                        })
//        })
//        return true 
//    }
}

