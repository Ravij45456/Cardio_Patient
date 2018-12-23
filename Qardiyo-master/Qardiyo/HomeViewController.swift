//
//  Ho
// ViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-22.
//  Edited by Jorge Gomez.
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import ResearchKit
import Alamofire
import SwifterSwift
import SVProgressHUD
import UserNotifications
import Quickblox
import QuickbloxWebRTC


 class HomeViewController: UIViewController, ORKTaskViewControllerDelegate {
    var player: AVAudioPlayer?
    var alert : UIAlertController?

    let opponentIds = [49734756]
    open var opponets: [QBUUser]?
    var currentUser: QBUUser?
    var users: [String : String]?
    var videoCapture: QBRTCCameraCapture?
    var session: QBRTCSession?
    
    @IBOutlet weak var constraintBottomSurveyButton: NSLayoutConstraint!
    @IBOutlet weak var constraintTopSurveyButton: NSLayoutConstraint!
    @IBOutlet weak var surveyButton: UIButton!
  @IBOutlet weak var heartSurveyBannerImg: UIImageView!
  
  @IBOutlet weak var heartSurveyImageWidth: NSLayoutConstraint!
  @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var helpView: UIView!
  
    let blueColor = UIColor(red: 25/255, green: 62/255, blue: 78/255, alpha: 1.0)
    let greenColor = UIColor(red: 123/255, green: 171/255, blue: 56/255, alpha: 1.0)
    var questionsArray = [Questions]()
    var steps = [ORKStep]()
  
    var step: ORKStep!
    var extraSteps = [ORKStep]()
    var numberOfYes: Int!
  
    var counter : ORKResult!
    var answers = [String]()
    var answersText = [String]()

    var questionString = [String]()
    var allParticipants = [[Dictionary<String,Any>]]()
    var threads: [String]!
    var surveyId: String!
    var surveyTitle: String!
    var theCurrentSurvey: Surveys!
    //var timer: Timer!

    let btnAllDone = UIButton()
    
    var opQueue = OperationQueue()
    
    var answerObject = [Dictionary<String,Any>]()
    var answerTextObject = [Dictionary<String,Any>]()
    
    @IBAction func emergencyCall(_ sender: UIButton) {
        
        if let phoneCallURL = URL(string: "tel://911") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
  @IBAction func takeSurveyTapped(_ sender: Any) {
      questionsArray = [Questions]()

      surveyButton.isUserInteractionEnabled = false
      SVProgressHUD.show()
      Surveys.getAssignedSurveys { (theSurvey) in
          if(theSurvey.checkForSurveys == "No"){
            self.surveyButton.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Sorry", message: "No surveys assigned to you at the moment.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go back", style: .default) { action in
                
            })
            SVProgressHUD.dismiss()
            self.present(alert, animated: true, completion: nil)
          } else {
            self.theCurrentSurvey = theSurvey
            self.questionsArray = self.getQuestionsfromSurvey(survey: theSurvey)
            self.createSurvey()
            self.surveyButton.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
          }
    }
  }
    
  func getQuestionsfromSurvey(survey: Surveys) -> [Questions]{
      //get questions of a survey
      var arrayOfQuestions: [Questions] = []
      let questions = survey.questions
      surveyId = survey.survey_id
      let dataUserDefaults = UserDefaults.standard
      dataUserDefaults.set(surveyId, forKey: "SurveyId")
      surveyTitle = survey.title
      for question in questions {
          let questionId = question["id"] as! String
          let questionTitle = question["title"] as! String
          let questionRequired = question["required"] as! String
          let questionResponse = question["response_type"] as! String
          var answerOptions = question["options"] as? [Dictionary<String,Any>]
          if answerOptions == nil {
            answerOptions = []
          }
          let newQuestion = Questions(id: questionId, question: questionTitle, required: questionRequired, responseType: questionResponse, options: answerOptions)
              //add Question object to the array to use it to display question in View Controller
          arrayOfQuestions.append(newQuestion)
        
      }
      return arrayOfQuestions
  }
  
    func getQuestionsfromExtraSurvey(survey: Surveys) -> [Questions]{
      //get questions of a survey
      var arrayOfQuestions: [Questions] = []
      let questions = survey.questions
      surveyId = survey.survey_id
      surveyTitle = survey.title
      for question in questions {
          let questionId = question["id"] as! String
          let questionTitle = question["title"] as! String
          let questionRequired = question["required"] as! String
          let questionResponse = question["response_type"] as! String
          var answerOptions = question["options"] as? [Dictionary<String,Any>]
          if answerOptions == nil {
            answerOptions = []
          }
          let newQuestion = Questions(id: questionId, question: questionTitle, required: questionRequired, responseType: questionResponse, options: answerOptions)
              //add Question object to the array to use it to display question in View Controller
          arrayOfQuestions.append(newQuestion)
        
      }
      return arrayOfQuestions
  }
  
  func createSurvey(){
    
      let instStep = ORKInstructionStep(identifier: "Instruction Step")
      instStep.title = "Tell us how you feel"
      steps += [instStep]
      for question in questionsArray {
        
        //ADD QUESTIONS WITH CUSTOMIZED ANSWERS
        var textChoice = [ORKTextChoice]()
        if(!question.options.isEmpty){
          
          let choices = question.options
          for choice in choices {
            let theChoice = choice["name"] as! String
            let theValue = choice["id"] as! String
            let addChoice = ORKTextChoice(text: theChoice, value: theValue as NSCoding & NSCopying & NSObjectProtocol)
            textChoice.append(addChoice)
          }

         let question = ORKQuestionStep(identifier: "\(question.id)", title: question.question, answer: ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice))
         
         question.isOptional = false
         steps += [question]
        }
        
        //ADD QUESTIONS WITH YES OR NO ANSWER
        else{
          
          let newquestion = ORKQuestionStep(identifier: "\(question.id)" , title: question.question , answer: ORKAnswerFormat.booleanAnswerFormat())
          newquestion.isOptional = true
          steps += [newquestion]
          //self.questionString.append(question.question)
        }
      }
    
      //COMPLETION SCREEN (WILL HAVE THE DONE BUTTON ON THE TOP RIGHT CORNER)
      let completionStep = ORKCompletionStep(identifier: "Completion Step")
      completionStep.title = "Thank you!"
      steps += [completionStep]

      let task = ORKOrderedTask(identifier: "\(surveyTitle)", steps: steps)
      let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
    
      taskViewController.delegate = self
      taskViewController.navigationBar.barTintColor = greenColor
      taskViewController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
      //SHOW THE SURVEY
      present(taskViewController, animated: true, completion: nil)
  }

    public func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        stepViewController.cancelButtonItem?.tintColor = blueColor
//        // added By ravi for testinf
//        for stepResult: ORKStepResult in (taskViewController.result.results as? [ORKStepResult])! {
//            for result in ([ORKResult]?(stepResult.results!))!{
//                if let questionResult = result as? ORKQuestionResult {
//                    if  questionResult.identifier  == "99" {
//                        continue
//                    }
//                }}}
//
//                    //****//
        
        var foundButton = false
        for view in taskViewController.view.subviews{
            if view.tag == 999{
                foundButton = true
                btnAllDone.isHidden = true
            }
        }

        if taskViewController.currentStepViewController?.step is ORKCompletionStep {
            if let results = taskViewController.result.results as? [ORKStepResult] {
                answers.removeAll()
                answersText.removeAll()
                
                for stepResult: ORKStepResult in results {
                    for result in ([ORKResult]?(stepResult.results!))!{
                        if let questionResult = result as? ORKQuestionResult {
                            answers.append("\(questionResult.answer!)")
                            
                            for question in questionsArray{
                                if question.id == result.identifier {
//                                    print("Question: \(question.question)")
                                    
                                    let quesAns = "\(questionResult.answer!)"
                                    
                                    if(quesAns == "1"){
                                        answersText.append("Yes")
                                    } else  if(quesAns == "0"){
                                        answersText.append("No")
                                    }else if question.options.count <= 0 {
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
            
            self.showAnswserVC(viewController: taskViewController)

            if foundButton == false {
                taskViewController.view.addSubview(btnAllDone)
            }else{

                btnAllDone.isHidden = false
            }
        }
    }
  //WHEN SURVEY IS DONE (AFTER PRESSING DONE BUTTON) IT WILL RUN THIS FUNCTION
  public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
    
        if (reason.rawValue == 1) {
          dismiss(animated: true, completion: nil)
        }
    
        //If reason.rawValue is 2,then survey was successfully completed.
        if(reason.rawValue == 2){
            answers.removeAll()
          if let results = taskViewController.result.results as? [ORKStepResult] {
              for stepResult: ORKStepResult in results {
                  for result in ([ORKResult]?(stepResult.results!))!{
                      if let questionResult = result as? ORKQuestionResult {
                          answers.append("\(questionResult.answer!)")
                      }
                  }
              }
          }
        
          numberOfYes = 0
            if questionsArray.count > 0 {
              for i in 0 ... questionsArray.count-1{
                let questionId = questionsArray[i].id.int
                var realAnswer = ""
                if(answers[i] == "1"){
                  realAnswer = "Yes"
                  numberOfYes = numberOfYes + 1
                } else if answers[i] == "0" {
                  realAnswer = "No"
                } else {
                  let temp = answers[i].replacing("(\n    ", with: "")
                  let temp2 = temp.replacing(")", with: "")
                  let temp3 = temp2.replacing("\n", with: "")
                  realAnswer = temp3
                  
                }
                answerObject.append([
                      "question_id": questionId!,
                      "answer": realAnswer
                ])
              }
            }
            
          if numberOfYes > 1 {
            //REQUEST EXTRA THREE QUESTIONS
            Surveys.getExtraQuestions(completed: { (survey) in
                let questions = self.getQuestionsfromExtraSurvey(survey: survey)
                let extraSurveyTitle = survey.title
              
                let instStep = ORKInstructionStep(identifier: "Extra Survey Questions")
                instStep.title = "3 extra questions"
                self.extraSteps += [instStep]
                
                for question in questions {
                  
                  if question.responseType.int! == 0 {
                    let continuousAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "", minimumValueDescription: "")
                    let continuousQuestionStepTitle = question.question
                    let sliderAnswer = ORKQuestionStep(identifier: "\(question.id)", title: continuousQuestionStepTitle, answer: continuousAnswerFormat)
                    sliderAnswer.isOptional = false
                    self.extraSteps += [sliderAnswer]
                    
                  }
                  else if question.responseType.int! == 2 {
                    //ADD QUESTIONS WITH CUSTOMIZED ANSWERS
                    var textChoice = [ORKTextChoice]()
                    if(!question.options.isEmpty){
                      
                      let choices = question.options
                      for choice in choices {
                        let theChoice = choice["name"] as! String
                        let theValue = choice["id"] as! String
                        let addChoice = ORKTextChoice(text: theChoice, value: theValue as NSCoding & NSCopying & NSObjectProtocol)
                        textChoice.append(addChoice)
                      }
                      
                      var questionId = question.id.int
                      questionId = questionId!
                     let question = ORKQuestionStep(identifier: "\(questionId!)", title: question.question, answer: ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice))
                     
                     question.isOptional = false
                     self.extraSteps += [question]
                     
                    }
                  }
                  //ADD QUESTIONS WITH YES OR NO ANSWER
                  else {
                      var questionId = question.id.int
                      questionId = questionId!
                      let newquestion = ORKQuestionStep(identifier: "\(questionId!)" , title: question.question , answer: ORKAnswerFormat.booleanAnswerFormat())
                      newquestion.isOptional = false
                      self.extraSteps += [newquestion]
                  }
                }
                //COMPLETION SCREEN (WILL HAVE THE DONE BUTTON ON THE TOP RIGHT CORNER)
                let completionStep = ORKCompletionStep(identifier: "Extra Survey Completion Step")
                completionStep.title = "Thank you for completing the survey."
                self.extraSteps += [completionStep]
                
                let surveyResultController = self.storyboard?.instantiateViewController(withIdentifier: "ExtraSurvey") as! SurveyViewController
                surveyResultController.extraSteps = self.extraSteps
                surveyResultController.questions = questions
                surveyResultController.firstSurveyQuestions = self.questionsArray
                surveyResultController.firstSurveyAnswers = self.answerObject
                surveyResultController.answersTextFirstSurvey = self.answersText
                surveyResultController.surveyTitle = extraSurveyTitle
                surveyResultController.survey_id = self.surveyId
                surveyResultController.parentVC = self
//                surveyResultController.modalPresentationStyle = .overCurrentContext

                taskViewController.dismiss(animated: true, completion: {
                    self.present(surveyResultController, animated: true, completion: nil)
                })

            })
          } else {
              //PRESNT ANSWERS IN TABLE VIEW
//              let resultController = self.storyboard?.instantiateViewController(withIdentifier: "SurveyResults") as! SurveyResultsVC
//              resultController.questions = self.questionsArray
//              resultController.answersSurvey1 = answerObject
//              resultController.noExtraAnswers = true
//              resultController.survey_id = self.surveyId
//              taskViewController.present(resultController, animated: true, completion: nil)
          }

          //SHOW THE USER PROGRESS (WHILE DOWNLOADING)
          SVProgressHUD.show()
          Surveys.submitSurveyAnswers(surveyCompleted: 0, answers: self.answerObject, completed: {
            SVProgressHUD.dismiss()
            //            Surveys.getAllCompletedSurveys(completed: { (completed_id) in
//              SVProgressHUD.dismiss()
//              let surveyResultController = self.storyboard?.instantiateViewController(withIdentifier: "SurveyResults") as! SurveyResultsVC
//              surveyResultController.questions = self.questionsArray
//                surveyResultController.answersSurvey1 = self.answerObject
//              surveyResultController.completed_survey_id = completed_id.int
//              taskViewController.present(surveyResultController, animated: true, completion: nil)
//           })
          })
          
          //If survey is not completed, it will return to home viw controller
//        } else {
//          let surveyResultController = self.storyboard?.instantiateViewController(withIdentifier: "goToTabBar") as! TabBarController
//          taskViewController.present(surveyResultController, animated: true, completion: nil)
//        }
    }
}
  
  
  @IBOutlet public var heartBeatLabel: UILabel!
    
  override public func viewDidLoad() {
        super.viewDidLoad()
        let modelName = UIDevice.current.modelName
        if(modelName == "iPhone 5s"){
//          heartSurveyBannerImg.contentMode = .scaleAspectFit
//          heartSurveyImageWidth.constant = 320
//          heartSurveyBannerImg.updateConstraints()
            
            constraintTopSurveyButton.constant = 10
            constraintBottomSurveyButton.constant = 10
            self.view.layoutIfNeeded()
        }
//
//        if(modelName == "iPhone 6s"){
//          heartSurveyBannerImg.contentMode = .scaleAspectFit
//          heartSurveyImageWidth.constant = 375
//          heartSurveyBannerImg.updateConstraints()
//        }
  
        HealthkitSetup.authorizeHealthKit { (authorized, error) in
        
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
    
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
    
        btnAllDone.frame = CGRect(x:(screenWidth - 200) / 2, y: screenHeight - 90, width: 200, height: 40)
        btnAllDone.setTitle("All Done", for: .normal)
        btnAllDone.tag = 999
        btnAllDone.layer.cornerRadius = 5
        btnAllDone.backgroundColor = greenColor
        btnAllDone.addTarget(self, action: #selector(touchOnAllDone), for: .touchUpInside)
    
        let dataUserDefaults = UserDefaults.standard
        let is_first_Login = dataUserDefaults.object(forKey: first_time_login) as? Bool ?? false
        if is_first_Login == true {
            dataUserDefaults.set(false, forKey: first_time_login)
            
            let alert = UIAlertController(title: "Cardio", message: "Do you want to change your password?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                let vc = QDChangePasswordViewController.storyboardInstance()
                vc?.modalPresentationStyle = .overCurrentContext
                self.present(vc!, animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "No", style: .default) { action in

            })
            
            self.opQueue.addOperation {
                // Put queue to the main thread which will update the UI
                OperationQueue.main.addOperation({
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    // Start automatic sync
    let autoSyncHeathData = AutoSyncHealthDataModel()
    autoSyncHeathData.startSyncAfterInter(time: 60)

  }
  
    func touchOnAllDone(){
        self.dismiss(animated: true, completion: {
            complete in
            
            self.numberOfYes = 0
            
            self.answerObject.removeAll()

            if self.questionsArray.count > 1 {
                for i in 0 ... self.questionsArray.count-1{
                    let questionId = self.questionsArray[i].id.int
                    var realAnswer = ""
                    if(self.answers[i] == "1"){
                        realAnswer = "Yes"
                        self.numberOfYes = self.numberOfYes + 1
                    } else if self.answers[i] == "0" {
                        realAnswer = "No"
                    } else {
                        let temp = self.answers[i].replacing("(\n    ", with: "")
                        let temp2 = temp.replacing(")", with: "")
                        let temp3 = temp2.replacing("\n", with: "")
                        realAnswer = temp3
                        
                    }
                    self.answerObject.append([
                        "question_id": questionId!,
                        "answer": realAnswer
                        ])
                    
                    // This constion added ME for tempory testing
                    if self.answersText[i] == "yes" || self.answersText[i] == "Yes" {
                        self.numberOfYes = self.numberOfYes + 1
                    }
                }
            }
            
            if self.numberOfYes >= 2 {
                Surveys.getExtraQuestions(completed: { (survey) in
                    let questions = self.getQuestionsfromExtraSurvey(survey: survey)
                    let extraSurveyTitle = survey.title
                    
                    let instStep = ORKInstructionStep(identifier: "Extra Survey Questions")
                    instStep.title = "3 extra questions"
                    self.extraSteps += [instStep]
                    
                    for question in questions {
                        
                        if question.responseType.int! == 0 {
                            let continuousAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 10, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "", minimumValueDescription: "")
                            let continuousQuestionStepTitle = question.question
                            let sliderAnswer = ORKQuestionStep(identifier: "\(question.id)", title: continuousQuestionStepTitle, answer: continuousAnswerFormat)
                            sliderAnswer.isOptional = false
                            self.extraSteps += [sliderAnswer]
                            
                        }
                        else if question.responseType.int! == 2 {
                            //ADD QUESTIONS WITH CUSTOMIZED ANSWERS
                            var textChoice = [ORKTextChoice]()
                            if(!question.options.isEmpty){
                                
                                let choices = question.options
                                for choice in choices {
                                    let theChoice = choice["name"] as! String
                                    let theValue = choice["id"] as! String
                                    let addChoice = ORKTextChoice(text: theChoice, value: theValue as NSCoding & NSCopying & NSObjectProtocol)
                                    textChoice.append(addChoice)
                                }
                                
                                var questionId = question.id.int
                                questionId = questionId!
                                let question = ORKQuestionStep(identifier: "\(questionId!)", title: question.question, answer: ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice))
                                
                                question.isOptional = false
                                self.extraSteps += [question]
                                
                            }
                        }
                            //ADD QUESTIONS WITH YES OR NO ANSWER
                        else {
                            var questionId = question.id.int
                            questionId = questionId!
                            let newquestion = ORKQuestionStep(identifier: "\(questionId!)" , title: question.question , answer: ORKAnswerFormat.booleanAnswerFormat())
                            newquestion.isOptional = false
                            self.extraSteps += [newquestion]
                        }
                    }
                    //COMPLETION SCREEN (WILL HAVE THE DONE BUTTON ON THE TOP RIGHT CORNER)
                    let completionStep = ORKCompletionStep(identifier: "Extra Survey Completion Step")
                    completionStep.title = "Thank you for completing the survey."
                    self.extraSteps += [completionStep]
                    
                    let surveyResultController = self.storyboard?.instantiateViewController(withIdentifier: "ExtraSurvey") as! SurveyViewController
                    surveyResultController.extraSteps = self.extraSteps
                    surveyResultController.questions = questions
                    surveyResultController.firstSurveyQuestions = self.questionsArray
                    surveyResultController.firstSurveyAnswers = self.answerObject
                    surveyResultController.answersTextFirstSurvey = self.answersText
                    surveyResultController.surveyTitle = extraSurveyTitle
                    surveyResultController.survey_id = self.surveyId
                    surveyResultController.parentVC = self
                    surveyResultController.modalPresentationStyle = .overCurrentContext
                    
                    self.present(surveyResultController, animated: true, completion: nil)
                })
            }else{
                Surveys.submitSurveyAnswers(surveyCompleted: 0, answers: self.answerObject, completed: {
                    SVProgressHUD.dismiss()
                })
            }
        })
    }
    
    func showAnswserVC(viewController:UIViewController){
        self.numberOfYes = 0
        
        if questionsArray.count > 0 {
            for i in 0 ... self.questionsArray.count-1{
                let questionId = self.questionsArray[i].id.int
                var realAnswer = ""
                if(self.answers[i] == "1"){
                    realAnswer = "Yes"
                    self.numberOfYes = self.numberOfYes + 1
                } else if self.answers[i] == "0" {
                    realAnswer = "No"
                } else {
                    let temp = self.answers[i].replacing("(\n    ", with: "")
                    let temp2 = temp.replacing(")", with: "")
                    let temp3 = temp2.replacing("\n", with: "")
                    realAnswer = temp3
                    
                }
                self.answerObject.append([
                    "question_id": questionId!,
                    "answer": realAnswer
                    ])
            }
        }
        
        
        let resultController = self.storyboard?.instantiateViewController(withIdentifier: "SurveyResults") as! SurveyResultsVC
        resultController.questions = self.questionsArray
        resultController.answersSurvey1 = self.answerObject
        resultController.noExtraAnswers = true
        resultController.survey_id = self.surveyId
        resultController.answersTextSurvey1 = self.answersText
        viewController.present(resultController, animated: true, completion: nil)
        
        resultController.didTouchOnDoneButton = {
            self.touchOnAllDone()
        }
    }
    
  public override func viewWillDisappear(_ animated: Bool) {
    
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "goToMessages"){
      SVProgressHUD.dismiss()
      let controller = segue.destination as! ConversationsVC
      controller.conversations = self.threads
    }
  }
  
  @IBAction func goToMessageButton(_ sender: Any) {
    SVProgressHUD.show()
    Messages.getConversations { (convs) in
        self.threads = convs
        Messages.getParticipants(threads: convs, completed: { (response) in
          self.performSegue(withIdentifier: "goToMessages", sender: nil)
        })
    }
  }
  
   
  public override func viewWillAppear(_ animated: Bool) {
      steps = [ORKStep]()
//      questionsArray = [Questions]()
      HeartRate.saveNewData()
    self.loginInQB()

  }
  
    //MARK: Video Calling Registration







func loginInQB() {
    let dataUserDefault = UserDefaults.standard
    //        let senderInfo = dataUserDefault.object(forKey: "quick_blox_id") as! Dictionary<String,Any>
    //       let quickBoxId = senderInfo["quick_blox_id"] as! String!
    
    let quickBoxId = dataUserDefault.object(forKey: "quick_blox_id") as! String
    
    QBRequest.user(withID: UInt(quickBoxId)!, successBlock: {(_ response: QBResponse, _ user: QBUUser) -> Void in
        // Successful response with user
        self.login(userLogin: user.login!, password: "qardiyo_user")
    }, errorBlock: {(_ response: QBResponse) -> Void in
        // Handle error
    })
}




func login(userLogin: String, password: String) {
    QBRequest.logIn(withUserLogin: userLogin, password: password, successBlock:{ r, user in
        // self.currentUser = user
        QBChat.instance.connect(with: user) { err in
            //let logins = self.users?.keys.filter {$0 != user.login}
            QBRequest.user(withLogin: user.login!, successBlock: { (r, u) in
                QBRTCClient.initializeRTC()
                QBRTCClient.instance().add(self)
                //self.configureBarButtons()
            }, errorBlock: { (rese) in
            })
        }
    })
}

}
extension HomeViewController:  QBRTCClientDelegate{
    
    
    //MARK: WebRTC configuration
    func cofigureVideo() {
        QBRTCConfig.mediaStreamConfiguration().videoCodec = .H264
        let videoFormat = QBRTCVideoFormat.init()
        videoFormat.frameRate = 21
        videoFormat.pixelFormat = .format420f
        videoFormat.width = 640
        videoFormat.height = 480
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: .front)
        self.videoCapture?.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        self.videoCapture?.startSession {
            let localView = LocalVideoView.init(withPreviewLayer:(self.videoCapture?.previewLayer)!)
            // self.stackView.addArrangedSubview(localView)
            
            QBRTCAudioSession.instance().currentAudioDevice = .speaker

            //QBRTCSoundRouter.instance.currentSoundRoute = QBRTCSoundRouteSpeaker
        }
    }
    
    func configureAudio() {
        //        self.stackView.isHidden = false
        QBRTCConfig.mediaStreamConfiguration().audioCodec = .codecOpus
        //Save current audio configuration before start call or accept call
        QBRTCAudioSession.instance().initialize()
        QBRTCAudioSession.instance().currentAudioDevice = .speaker
        //OR you can initialize audio session with a specific configuration
        QBRTCAudioSession.instance().initialize { (configuration: QBRTCAudioSessionConfiguration) -> () in
            
            var options = configuration.categoryOptions
            if #available(iOS 10.0, *) {
                options = options.union(AVAudioSessionCategoryOptions.allowBluetoothA2DP)
                options = options.union(AVAudioSessionCategoryOptions.allowAirPlay)
            } else {
                options = options.union(AVAudioSessionCategoryOptions.allowBluetooth)
            }
            
            configuration.categoryOptions = options
            configuration.mode = AVAudioSessionModeVideoChat
        }
        
    }
    
    
    public func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        
        if self.session == nil {
            self.session = session
            handleIncomingCall()
        }
       
    }
    
    public func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
        
        if (session as! QBRTCSession).id == self.session?.id {
            if session.conferenceType == QBRTCConferenceType.video {
                //                self.screenShareBtn.isHidden = false
            } else{
                navigateToCall(isAudio: true)
            }
        }
    }
    
    public func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        
        if session.id == self.session?.id {

            self.removeRemoteView(with: userID.uintValue)
            if userID == session.initiatorID {
                self.session?.hangUp(nil)
               // videoTrack = nil

            }
        }
    }
    
    public func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
        if (session as! QBRTCSession).id == self.session?.id {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
            nextViewController.currentUser =  self.currentUser
            nextViewController.videoTrack = videoTrack
            nextViewController.userID = userID
            nextViewController.baseSession = session
            nextViewController.session = self.session
            // self.navigationController?.pushViewController(nextViewController, animated: true)
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                topController.present(nextViewController, animated: true, completion: nil)
                // topController.navigationController?.pushViewController(nextViewController, animated: true)
                
            }
        }
    }
    
    func logOut() {
        QBChat.instance.disconnect { (err) in
            QBRequest .logOut(successBlock: { (r) in
            })
        }
    }
    
    
    
    
    public func sessionDidClose(_ session: QBRTCSession) {
        let dataUserDefault = UserDefaults.standard
        if session.id == self.session?.id {
            // self.callBtn.isHidden = false
            //self.logoutBtn.isEnabled = true
            //            self.screenShareBtn.isHidden = true
//            let ids = self.opponets?.map({$0.id})
//
//             for userID in opponentIds {
//            let senderInfo = dataUserDefault.object(forKey: "quick_blox_ids") as! Dictionary<String,Any>
//            let quickBoxId = senderInfo["quick_blox_id"] as? String
//            self.removeRemoteView(with: UInt(quickBoxId!)!)
            
                self.session = nil
            self.player?.stop()
            alert?.dismiss(animated: true, completion: nil)
            alert = nil

           //  }
        }
    }
    
    //MARK: Helpers
    
    func resumeVideoCapture() {
        // ideally you should always stop capture session
        // when you are leaving controller in any way
        // here we should get its running state back
//        if self.videoCapture != nil && !(self.videoCapture?.hasStarted)! {
//            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
//            self.videoCapture?.startSession(nil)
//        }
    }
    
    func removeRemoteView(with userID: UInt) {
        //        self.stackView.isHidden = false
        //    for view in self.stackView.arrangedSubviews {
        //        if view.tag == userID {
        //            self.stackView.removeArrangedSubview(view)
        //        }
        //    }
    }
    
    
    
    func handleIncomingCall() {
        
        alert = UIAlertController.init(title: "Incoming video call", message: "Accept ?", preferredStyle: .actionSheet)
        
        let accept = UIAlertAction.init(title: "Accept", style: .default) { action in
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.session?.acceptCall(nil)
            self.player?.stop()

        }
        
        let reject = UIAlertAction.init(title: "Reject", style: .default) { action in
            self.session?.rejectCall(nil)
            self.player?.stop()

        }
        
        alert?.addAction(accept)
        alert?.addAction(reject)
        // self.present(alert, animated: true)
        // Utility.showAlertMessage(vc: self, titleStr:"Incomming call", messageStr:"Video call")
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert!, animated: true, completion: nil)
        playSound()
    }
    
    
    func navigateToCall(isAudio: Bool) {
        self.logOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
        nextViewController.currentUser =  self.currentUser
        nextViewController.isAudio = isAudio
      //  self.navigationController?.pushViewController(nextViewController, animated: true)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(nextViewController, animated: true, completion: nil)
    }
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "default", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint:AVMediaTypeAudio)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.numberOfLoops = 3
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}



