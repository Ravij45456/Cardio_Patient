
//
//  SurveyResultsVC.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-02-14.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import ResearchKit

class SurveyResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ORKTaskViewControllerDelegate  {
 
  let greenColor = UIColor(red: 123/255, green: 171/255, blue: 56/255, alpha: 1.0)
  //Added by RAvi
  //  var numberOfYes  = 0
    
    var token: String!
    var questions = [Questions]()
    var allAnswers = [String]()
    var answersSurvey1 = [Dictionary<String,Any>]()
    var answersSurvey2 = [Dictionary<String,Any>]()
    var survey_title: String!
    var survey_id: String!
  
    var answersTextSurvey1 = [String]()
    var answersTextSurvey2 = [String]()
    var allAnswersText = [String]()

    var extraSteps = [ORKStep]()
    var completed_survey_id: Int!
    var extraAnswers: Bool = false
    var noExtraAnswers: Bool = false
  
    var didTouchOnDoneButton:(() -> Void)?

  override func viewDidLoad() {
        super.viewDidLoad()
        let userDataDefaults = UserDefaults.standard
        token = userDataDefaults.object(forKey: "auth_token") as! String
    
    
        if extraAnswers{
          if !answersSurvey2.isEmpty{
            for answer in answersSurvey2 {
                let theAnswer = answer["answer"] as! String
                allAnswers.append(theAnswer)
            }
          }
        }
    
        if noExtraAnswers {
          if !answersSurvey1.isEmpty {
            for answer in answersSurvey1 {
              let theAnswer = answer["answer"] as! String
              allAnswers.append(theAnswer)
            }
            


          }
        }
    
    for answerText in answersTextSurvey2 {
        allAnswersText.append("\(answerText)")
    }
    
    for answerText in answersTextSurvey1 {
        allAnswersText.append("\(answerText)")
    }
  }
  
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    //go back to home
    //let completedSurveyId = survey_id.int!
    var yesAnswerCont = 0
    for answerString in self.allAnswersText{
        if answerString == "yes" || answerString == "Yes" {
            yesAnswerCont = yesAnswerCont + 1
        }
    }
    
    let completedSurveyId = yesAnswerCont
    
    if extraAnswers {
      Surveys.submitSurveyAnswers(surveyCompleted: completedSurveyId, answers: answersSurvey2) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
        self.present(homeVC, animated: true, completion: nil)
      }
    }

    if noExtraAnswers {
      Surveys.submitSurveyAnswers(surveyCompleted: completedSurveyId, answers: answersSurvey1) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
        self.present(homeVC, animated: true, completion: nil)
      }
    }
    self.didTouchOnDoneButton?()
    
    self.dismiss(animated: true, completion: nil)
  }
  
  public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {

      //Post answers to the server here. FIRST survey and SECOND survey (if available).
      let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
      taskViewController.present(homeVC, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return questions.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! SelfAssessmentCell
    
      let question = self.questions[indexPath.row]
      let answered = self.allAnswersText[indexPath.row]
      cell.updateUI(questionText: question.question, answerText: answered, questionNumber: indexPath.row+1)
    
      return cell
  }

}
