//
//  SplashScreenViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-12-07.
//  Edited by Jorge Gomez
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import LocalAuthentication
import UserNotifications
import Quickblox
import QuickbloxWebRTC


// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "QardiyoHF"
    static let accessGroup: String? = nil
}

class SplashScreenViewController: UIViewController,UITextFieldDelegate {
    
//    let opponentIds = [49734756]
//    open var opponets: [QBUUser]?
//    var currentUser: QBUUser?
//    var users: [String : String]?
//
//    var videoCapture: QBRTCCameraCapture?
//    var session: QBRTCSession?

  
    @IBOutlet weak var pwdTextField: UITextField!{
        didSet{
            if let password =  UserDefaults.standard.object(forKey: "currentPassword") as? String{
                pwdTextField.text = password
            }
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            if let email =  UserDefaults.standard.object(forKey: "currentLoginId") as? String{
                emailTextField.text = email
            }
        }
    }
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
    @IBOutlet weak var touchIDButton: UIButton!
    
   
    
  private var loginIdentifier = "loginSuccess"
  //user_id=123456
  //auth_code=B16vC6pqra
  //"http://34.201.26.247/api/qardiyo/authenticate?user_id=123456&authorization_code=B16vC6pqra"
  
    var authenticationContext = LAContext()

  override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        touchIDButton.isHidden = !canEvaluatePolicy()
    
        pwdTextField.delegate = self
        emailTextField.delegate = self
    
        // check password and username have stored in keychain, if not, will set touch id button hidden
        do {
            let username = UserDefaults.standard.value(forKey: username_keychain) as? String ?? " "
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)

            _ = try passwordItem.readPassword()
            touchIDButton.isHidden = false
        }
        catch {
            touchIDButton.isHidden = true
        }
        authenticationContext.localizedFallbackTitle = ""
    
        let dataUserDefault = UserDefaults.standard
//        let firstTime = dataUserDefault.object(forKey: "first_time") as? Bool
//        if(firstTime == nil){
//            dataUserDefault.set(false, forKey: "first_time")
//            let vc = WelcomePagesVC.storyboardInstance()
//            self.present(vc!, animated: true, completion: nil)
//        }
    // added by Ravi for showing the term and condition screen
    let isAgreedTerm = dataUserDefault.object(forKey: "isAgreeTerm") as? Bool
    if(isAgreedTerm == false || isAgreedTerm == nil){
        dataUserDefault.set(false, forKey: "isAgreeTerm")
        //  let vc = WelcomePagesVC.storyboardInstance()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let termAndCondtion = storyboard.instantiateViewController(withIdentifier: "PSTermsAndCondictionsViewController") as! PSTermsAndCondictionsViewController
        self.present(termAndCondtion, animated: false, completion: nil)
        //   self.performSegue(withIdentifier: "termAnsCondtionSeque", sender: self)
    }
    }
    
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
    func canEvaluatePolicy() -> Bool {
        return authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
  @IBAction func forgotPwdPressed(_ sender: UIButton) {
      //reset password in the backend
    
  }
  
    @IBAction func touchOnForgotPassword(_ sender: Any) {
    }
    
    
    @IBAction func touchOnLoginWithTouchID(_ sender: Any) {
        var error:NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Login by Touch ID",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    let username = UserDefaults.standard.value(forKey: username_keychain) as? String ?? ""
                    
                    do {
                        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                account: username,
                                                                accessGroup: KeychainConfiguration.accessGroup)
                        let keychainPassword = try passwordItem.readPassword()
                        DispatchQueue.main.async {
                            self.emailTextField.text = username
                            self.pwdTextField.text = keychainPassword
                            self.loginPressed(UIButton())
                        }
                    }
                    catch {
//                        fatalError("Error reading password from keychain - \(error)")
                    }
                    

                }else {
//                    if let error = error {
//                        debugPrint(error)
//                        self.showAlertViewAfterEvaluatingPolicyWithMessage(error.localizedDescription)
//                    }
                }
        })
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        showAlertWithTitle("Error", message: "This device does not have a TouchID sensor. Probably, you have authorized over 5 time unsuccessfully.")
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( _ message:String ){
        showAlertWithTitle("Error", message: message)
    }
    
    func showAlertWithTitle( _ title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
//    emailTextField.text = "101"
//    pwdTextField.text = "123456"

   if(emailTextField.text != "" && pwdTextField.text != ""){
      SVProgressHUD.show()
      Alamofire.request("\(AUTH_URL)user_id=\(emailTextField.text!)&authorization_code=\(pwdTextField.text!)")
      //
      //
          .responseJSON { response in
              debugPrint(response)
              print(response)
              //if username and password is current enter statement
              if(response.result.isSuccess) {
                
                
                
                // save username and password to keychain
                do {
                    UserDefaults.standard.setValue(self.emailTextField.text!, forKey: username_keychain)

                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                            account: self.emailTextField.text!,
                                                            accessGroup: KeychainConfiguration.accessGroup)
                    
                    // Save the password for the new item.
                    try passwordItem.savePassword(self.pwdTextField.text!)
                } catch {
                    fatalError("Error updating keychain - \(error)")
                }

                
                let token = response.result.value as! Dictionary<String, Any>
                let dataUserDefault = UserDefaults.standard
                dataUserDefault.set(token["auth_token"] as! String, forKey: "auth_token")
                //Ravi
                // Quick blocks id
                
                 dataUserDefault.set(token["quick_blox_id"] as! String, forKey: "quick_blox_id")
                dataUserDefault.set(token["pid"] as! String, forKey: "patientId")
                
                let last_login = token["last_login"] as? String ?? ""
                print(last_login)
                if last_login != "" {
//                    print("last login: \(String(describing: token["last_login"]))")
                    dataUserDefault.set(false, forKey: first_time_login)
                }else{
//                    print("First time)")
                    dataUserDefault.set(true, forKey: first_time_login)
                }
                
                UserProfile.saveDeviceToken {

                }
                SVProgressHUD.dismiss()
                
                dataUserDefault.set(self.pwdTextField.text! , forKey: "currentPassword")
                dataUserDefault.set(self.emailTextField.text! , forKey: "currentLoginId")
                 dataUserDefault.set(true , forKey: "autoLogin")
                dataUserDefault.synchronize()
              //  self.pwdTextField.text = ""
              //  self.emailTextField.text = ""
                self.authenticationContext = LAContext()
                
                //After the successfull login syncing data started
                let autoSyncHeathData = AutoSyncHealthDataModel()
                autoSyncHeathData.startSyncAfterInter(time: 60)
                
              //  self.loginInQB()
                self.performSegue(withIdentifier: "goToHome", sender: nil)
                
//                let firstTime = dataUserDefault.object(forKey: "first_time") as? Bool
//                if(firstTime == nil){
//                  dataUserDefault.set(false, forKey: "first_time")
//                  SVProgressHUD.dismiss()
//                  self.performSegue(withIdentifier: "goToWelcome", sender: nil)
//                }
//                else{
//                  SVProgressHUD.dismiss()
//                  self.performSegue(withIdentifier: "goToHome", sender: nil)
//                }
              } else {
                //else display message to user
                
                let alert = UIAlertController(title: "Error", message: "Invalid user", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default) { action in
                
                })
                SVProgressHUD.dismiss()
                self.present(alert, animated: true, completion: nil)
              }
       }
    } else {
        let alert = UIAlertController(title: "Error", message: "Email or password cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
        
        })
        SVProgressHUD.dismiss()
        self.present(alert, animated: true, completion: nil)
    }
    
  }
    
    
    
    
//    func loginInQB() {
//        let dataUserDefault = UserDefaults.standard
//        //        let senderInfo = dataUserDefault.object(forKey: "quick_blox_id") as! Dictionary<String,Any>
//        //       let quickBoxId = senderInfo["quick_blox_id"] as! String!
//
//        let quickBoxId = dataUserDefault.object(forKey: "quick_blox_id") as! String
//
//        QBRequest.user(withID: UInt(quickBoxId)!, successBlock: {(_ response: QBResponse, _ user: QBUUser) -> Void in
//            // Successful response with user
//            self.login(userLogin: user.login!, password: "qardiyo_user")
//        }, errorBlock: {(_ response: QBResponse) -> Void in
//            // Handle error
//        })
//    }
//
//
//
//
//
//func login(userLogin: String, password: String) {
//    QBRequest.logIn(withUserLogin: userLogin, password: password, successBlock:{ r, user in
//       // self.currentUser = user
//        QBChat.instance.connect(with: user) { err in
//            //let logins = self.users?.keys.filter {$0 != user.login}
//            QBRequest.user(withLogin: user.login!, successBlock: { (r, u) in
//                QBRTCClient.initializeRTC()
//                QBRTCClient.instance().add(self)
//                //self.configureBarButtons()
//            }, errorBlock: { (rese) in
//            })
//        }
//    })
//}
    
    
    
    
    
  
    func errorMessageForLAErrorCode( _ errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.Code.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.Code.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.Code.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.Code.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.Code.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.Code.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.Code.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.Code.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.Code.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    //MARK: Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if !(self.pwdTextField.text?.isEmpty)! && !(self.emailTextField.text?.isEmpty)!{
            self.loginPressed(UIButton())
        }
        return true
    }
    
}

extension UIViewController
{
  func hideKeyboardWhenTappedAround()
  {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard()
  {
    view.endEditing(true)
  }
}


//extension SplashScreenViewController: UNUserNotificationCenterDelegate, QBRTCClientDelegate{
//
//
////MARK: WebRTC configuration
//func cofigureVideo() {
//    QBRTCConfig.mediaStreamConfiguration().videoCodec = .H264
//    let videoFormat = QBRTCVideoFormat.init()
//    videoFormat.frameRate = 21
//    videoFormat.pixelFormat = .format420f
//    videoFormat.width = 640
//    videoFormat.height = 480
//
//    self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: .front)
//    self.videoCapture?.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
//
//    self.videoCapture?.startSession {
//        let localView = LocalVideoView.init(withPreviewLayer:(self.videoCapture?.previewLayer)!)
//       // self.stackView.addArrangedSubview(localView)
//    }
//}
//
//func configureAudio() {
//    //        self.stackView.isHidden = false
//    QBRTCConfig.mediaStreamConfiguration().audioCodec = .codecOpus
//    //Save current audio configuration before start call or accept call
//    QBRTCAudioSession.instance().initialize()
//    QBRTCAudioSession.instance().currentAudioDevice = .speaker
//    //OR you can initialize audio session with a specific configuration
//    QBRTCAudioSession.instance().initialize { (configuration: QBRTCAudioSessionConfiguration) -> () in
//
//        var options = configuration.categoryOptions
//        if #available(iOS 10.0, *) {
//            options = options.union(AVAudioSessionCategoryOptions.allowBluetoothA2DP)
//            options = options.union(AVAudioSessionCategoryOptions.allowAirPlay)
//        } else {
//            options = options.union(AVAudioSessionCategoryOptions.allowBluetooth)
//        }
//
//        configuration.categoryOptions = options
//        configuration.mode = AVAudioSessionModeVideoChat
//    }
//
//}
//
//
//func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
//
//    if self.session == nil {
//        self.session = session
//        handleIncomingCall()
//    }
//}
//
//func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
//
//    if (session as! QBRTCSession).id == self.session?.id {
//        if session.conferenceType == QBRTCConferenceType.video {
//            //                self.screenShareBtn.isHidden = false
//        }
//    }
//}
//
//func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//
//    if session.id == self.session?.id {
//
//        self.removeRemoteView(with: userID.uintValue)
//        if userID == session.initiatorID {
//            self.session?.hangUp(nil)
//        }
//    }
//}
//
//func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
//    if (session as! QBRTCSession).id == self.session?.id {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
//        nextViewController.currentUser =  self.currentUser
//        nextViewController.videoTrack = videoTrack
//        nextViewController.userID = userID
//        nextViewController.baseSession = session
//        nextViewController.session = self.session
//       // self.navigationController?.pushViewController(nextViewController, animated: true)
//
//        if var topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//
//            topController.present(nextViewController, animated: true, completion: nil)
//// topController.navigationController?.pushViewController(nextViewController, animated: true)
//
//        }
//    }
//}
//
//func logOut() {
//    QBChat.instance.disconnect { (err) in
//        QBRequest .logOut(successBlock: { (r) in
//        })
//    }
//}
//
//
//
//
//func sessionDidClose(_ session: QBRTCSession) {
//    let dataUserDefault = UserDefaults.standard
//    if session.id == self.session?.id {
//        // self.callBtn.isHidden = false
//        //self.logoutBtn.isEnabled = true
//        //            self.screenShareBtn.isHidden = true
//        //let ids = self.opponets?.map({$0.id})
//
//        // for userID in opponentIds {
//        let senderInfo = dataUserDefault.object(forKey: "quick_blox_ids") as! Dictionary<String,Any>
//        let quickBoxId = senderInfo["quick_blox_id"] as? String
//        self.removeRemoteView(with: UInt(quickBoxId!)!)
//        //  }
//        self.session = nil
//    }
//}
//
////MARK: Helpers
//
//func resumeVideoCapture() {
//    // ideally you should always stop capture session
//    // when you are leaving controller in any way
//    // here we should get its running state back
//    if self.videoCapture != nil && !(self.videoCapture?.hasStarted)! {
//        self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
//        self.videoCapture?.startSession(nil)
//    }
//}
//
//func removeRemoteView(with userID: UInt) {
//    //        self.stackView.isHidden = false
////    for view in self.stackView.arrangedSubviews {
////        if view.tag == userID {
////            self.stackView.removeArrangedSubview(view)
////        }
////    }
//}
//
//func handleIncomingCall() {
//
//    let alert = UIAlertController.init(title: "Incoming video call", message: "Accept ?", preferredStyle: .actionSheet)
//
//    let accept = UIAlertAction.init(title: "Accept", style: .default) { action in
//        self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
//        self.session?.acceptCall(nil)
//    }
//
//    let reject = UIAlertAction.init(title: "Reject", style: .default) { action in
//        self.session?.rejectCall(nil)
//    }
//
//    alert.addAction(accept)
//    alert.addAction(reject)
//   // self.present(alert, animated: true)
//   // Utility.showAlertMessage(vc: self, titleStr:"Incomming call", messageStr:"Video call")
//    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//    alertWindow.rootViewController = UIViewController()
//    alertWindow.windowLevel = UIWindowLevelAlert + 1;
//    alertWindow.makeKeyAndVisible()
//    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//}
//
//
//func navigateToCall(isAudio: Bool) {
//    self.logOut()
//    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
//    nextViewController.currentUser =  self.currentUser
//    nextViewController.isAudio = isAudio
//    self.navigationController?.pushViewController(nextViewController, animated: true)
//}
//
//}

