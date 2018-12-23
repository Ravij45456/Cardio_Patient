//
//  CallViewController.swift
//  sample-videochat-webrtc-swift
//
//  Created by QuickBlox team
//  Copyright © 2018 QuickBlox. All rights reserved.
//

import UIKit

import Quickblox
import QuickbloxWebRTC
import SVProgressHUD

class CallViewController: UIViewController, QBRTCClientDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var screenShareBtn: UIButton!
    
    var views: [UIView] = []
    
    
    open var opponets: [QBUUser]?
    open var currentUser: QBUUser?
    var isAudio: Bool = false
    
    var videoCapture: QBRTCCameraCapture?
    
    var session: QBRTCSession?
    var baseSession :QBRTCBaseSession?
    var users: [String : String]?
    var opponentIds = [UInt]()
    
    var videoTrack : QBRTCVideoTrack?
    var userID : NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataUserDefault = UserDefaults.standard
       // let senderInfo = dataUserDefault.object(forKey: "quick_blox_ids") as! Dictionary<String,Any>
      //  opponentIds.append(UInt(senderInfo["quick_blox_id"] as! String)!)
        
        
        UIApplication.shared.isIdleTimerDisabled = true
        self.title = self.currentUser?.fullName
        self.navigationItem.rightBarButtonItem = nil
        if isAudio {
            configureAudio()
        } else {
            cofigureVideo()
        }
        if userID != 0 {
            SVProgressHUD.show(withStatus: "Waiting For Your Friend")
            self.commonRemote(baseSession!, videoTrack: videoTrack!, fromUser: userID)
        } else {
           // SVProgressHUD.show(withStatus: "Calling...")
            //  self.login(userLogin: "shivam90", password: "shivam@123")
            
            let dataUserDefault = UserDefaults.standard
            let quickBoxId = dataUserDefault.object(forKey: "quick_blox_id") as! String
            QBRequest.user(withID: UInt(quickBoxId)!, successBlock: {(_ response: QBResponse, _ user: QBUUser) -> Void in
                // Successful response with user
                self.login(userLogin: user.login!, password: "qardiyo_user")
            }, errorBlock: {(_ response: QBResponse) -> Void in
                // Handle error
            })
        }
    }
    
    func login(userLogin: String, password: String) {
        QBRequest.logIn(withUserLogin: userLogin, password: password, successBlock:{ r, user in
            self.currentUser = user
            QBChat.instance.connect(with: user) { err in
                QBRequest.user(withLogin: user.login!, successBlock: { (r, u) in
                    QBRTCClient.initializeRTC()
                    QBRTCClient.instance().add(self)
                    if self.isAudio {
                        self.session = QBRTCClient.instance().createNewSession(withOpponents: self.opponentIds as [NSNumber], with: .audio)
                    } else {
                        self.session = QBRTCClient.instance().createNewSession(withOpponents: self.opponentIds as [NSNumber], with: .video)
                    }
                    self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
                    self.session?.startCall(["info" : "user info"])
                }, errorBlock: { (rese) in
                })
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.resumeVideoCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SVProgressHUD.dismiss()
       // self.session = nil
    }
    
    //MARK: WebRTC configuration
    
    func cofigureVideo() {
        
        QBRTCClient.instance().add(self)
        
        let videoFormat = QBRTCVideoFormat.init()
        videoFormat.frameRate = 30
        videoFormat.pixelFormat = .format420f
        videoFormat.width = 640
        videoFormat.height = 480
        
        // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.front)
        
        // add video capture to session's local media stream
        // from version 2.3 you no longer need to wait for 'initializedLocalMediaStream:' delegate to do it
        self.session!.localMediaStream.videoTrack.videoCapture = self.videoCapture
        
       // self.videoCapture!.previewLayer.frame = self.opponentVideoView.bounds
        
        QBRTCConfig.mediaStreamConfiguration().audioCodec = .codecOpus
        //Save current audio configuration before start call or accept call
        QBRTCAudioSession.instance().initialize()
        QBRTCAudioSession.instance().currentAudioDevice = .speaker
        
        self.videoCapture!.startSession()

        self.opponentVideoView.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)
        let localView = LocalVideoView.init(withPreviewLayer:(self.videoCapture?.previewLayer)!)
                    self.stackView.addArrangedSubview(localView)
        self.stackView.addArrangedSubview(localView)
        

        
        //        QBRTCConfig.mediaStreamConfiguration().videoCodec = .H264
        //        let videoFormat = QBRTCVideoFormat.init()
        //        videoFormat.frameRate = 21
        //        videoFormat.pixelFormat = .format420f
        //        videoFormat.width = 640
        //        videoFormat.height = 480
        //        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: .front)
        //        self.videoCapture.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        //        self.videoCapture.startSession {
        //            let localView = LocalVideoView.init(withPreviewLayer:self.videoCapture.previewLayer)
        //            self.stackView.addArrangedSubview(localView)
        //        }
        //
        
//        QBRTCConfig.mediaStreamConfiguration().videoCodec = .H264
//
//        let videoFormat = QBRTCVideoFormat()
//        videoFormat.frameRate = 21
//        videoFormat.pixelFormat = .format420f
//        videoFormat.width = 640
//        videoFormat.height = 480
//
//        self.videoCapture = QBRTCCameraCapture(videoFormat: videoFormat, position: .front)
//        self.videoCapture.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
//
//        self.videoCapture.startSession {
//
//            let localView = LocalVideoView(withPreviewLayer:self.videoCapture.previewLayer)
//             self.views.append(localView)
//            self.stackView.addArrangedSubview(localView)
//        }
        
    }
    
    func configureAudio() {
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
    
    //MARK: Actions
    
    @IBAction func didPressLogout(_ sender: Any) {
        self.logout()
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressCall(_ sender: UIButton) {
        
    }
    
    @IBAction func didPressEnd(_ sender: UIButton) {
        SVProgressHUD.dismiss()
        if self.session != nil {
            self.session?.hangUp(nil)
        }
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        SVProgressHUD.dismiss()
        if self.session == nil {
            self.session = session
            self.session?.localMediaStream.audioTrack.isEnabled = !(self.session?.localMediaStream.audioTrack.isEnabled)!
                QBRTCAudioSession.instance().currentAudioDevice = .speaker
        }
    }
    
    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
        if (session as! QBRTCSession).id == self.session?.id {
            if session.conferenceType == QBRTCConferenceType.video {
            }
        }
    }
    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        if session.id == self.session?.id {
            self.removeRemoteView(with: userID.uintValue)
            if userID == session.initiatorID {
                self.session?.hangUp(nil)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        else if session.conferenceType == QBRTCConferenceType.audio{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBOutlet weak var opponentVideoView: QBRTCRemoteVideoView!
    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
        self.commonRemote(session, videoTrack: videoTrack, fromUser: userID)
        
        self.opponentVideoView?.setVideoTrack(videoTrack)

    }
    
    func commonRemote(_ session: QBRTCBaseSession, videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber ) {
        SVProgressHUD.dismiss()
        if (session as! QBRTCSession).id == self.session?.id {
            let remoteView :QBRTCRemoteVideoView = QBRTCRemoteVideoView.init()
            remoteView.videoGravity = AVLayerVideoGravityResizeAspect
            remoteView.clipsToBounds = true
            remoteView.setVideoTrack(videoTrack)
            remoteView.tag = userID.intValue
            self.stackView.addArrangedSubview(remoteView)
        }
    }
    
    func sessionDidClose(_ session: QBRTCSession) {
        if session.id == self.session?.id {
            for userID in opponentIds {
                self.removeRemoteView(with: userID)
            }
            videoTrack = nil
            self.session = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    
    func resumeVideoCapture() {
        // ideally you should always stop capture session
        // when you are leaving controller in any way
        // here we should get its running state back
        if self.videoCapture != nil && !(self.videoCapture?.hasStarted)! {
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.videoCapture?.startSession(nil)
        }
    }
    
    func removeRemoteView(with userID: UInt) {
        
        for view in self.stackView.arrangedSubviews {
            if view.tag == userID {
                self.stackView.removeArrangedSubview(view)
            }
        }
        
    }
    
    func logout() {
        QBChat.instance.disconnect { (err) in
            QBRequest .logOut(successBlock: { (r) in
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.dismiss(animated: true, completion: nil)
                }            })
        }
    }
}
