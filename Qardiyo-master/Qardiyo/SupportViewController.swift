//
//  SupportViewController.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-22.
//  Edited by Jorge Gomez
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.


import UIKit
import JSQMessagesViewController
import IQKeyboardManagerSwift
import Alamofire
import SVProgressHUD
import UserNotifications
import Quickblox
import QuickbloxWebRTC
import AVFoundation
import AVKit
import Quickblox
import MobileCoreServices
import Kingfisher
import  NYTPhotoViewer
import BFRImageViewer
import BMPlayer



class SupportViewController: JSQMessagesViewController, UNUserNotificationCenterDelegate, QBRTCClientDelegate {
    
    //    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: Properties
    var message = [JSQMessage]()
    let blueColor = UIColor(red: 25/255, green: 62/255, blue: 78/255, alpha: 1.0)
    let greenColor = UIColor(red: 123/255, green: 171/255, blue: 56/255, alpha: 1.0)
    var currentThread: String! = ""
    var current_user_token: String! = ""
    var allMessages = [Messages]()
    var participants = [Dictionary<String,Any>]()
    let dataUserDefault = UserDefaults.standard
    var unreadMessages: [Messages] = []
    var timer: Timer!
    var threads: [String]!
    
    var imagePicker     = UIImagePickerController()
    var imgSelected     = UIImage()
    var selectedMediaImg    = UIImage()
    var strImage        = String()
    
    var stackView = UIStackView()
    
    var stackContainer = UIView()
    var btnVideo = UIButton()
    var btnAudio = UIButton()
    var inProcess = false
    
    
    
    let opponentIds = [49734756]
    open var opponets: [QBUUser]?
    var currentUser: QBUUser?
    var users: [String : String]?
    
    var videoCapture: QBRTCCameraCapture!
    var session: QBRTCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let receiverInfo = dataUserDefault.object(forKey: "receiver") as! Dictionary<String,Any>
        let senderInfo = dataUserDefault.object(forKey: "sender") as! Dictionary<String,Any>
        self.senderDisplayName = senderInfo["full_name"] as! String!
        self.senderId = senderInfo["user_uuid"] as! String!
        self.navigationItem.title = receiverInfo["full_name"] as! String!
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        self.navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: blueColor]
           SVProgressHUD.show()
        self.checkForUnreadMessages()
       // theTimer()
       // addingMessages()
        //self.login(userLogin: "raajpoot90", password: "raajpoot90")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        btnVideo.isHidden = true
        btnAudio.isHidden = true
        
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
            self.currentUser = user
            QBChat.instance.connect(with: user) { err in
                //let logins = self.users?.keys.filter {$0 != user.login}
                QBRequest.user(withLogin: user.login!, successBlock: { (r, u) in
                    QBRTCClient.initializeRTC()
                    QBRTCClient.instance().add(self)
                    self.configureBarButtons()
                }, errorBlock: { (rese) in
                })
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
        // Ravi
        // This functionality is depricated
        theTimer()
    }
    
    func configureBarButtons() {
        btnVideo.isHidden = false
        btnAudio.isHidden = false
        btnVideo = UIButton.init(type: .custom)
        btnVideo.setImage(UIImage(named: "video.png"), for: UIControlState.normal)
       // btnVideo.addTarget(self, action: #selector(self.video), for: UIControlEvents.touchUpInside)
        btnAudio = UIButton.init(type: .custom)
        btnAudio.setImage(UIImage(named: "audio.png"), for: UIControlState.normal)
       // btnAudio.addTarget(self, action: #selector(self.audio), for: UIControlEvents.touchUpInside)
       // remove adudio and video calling button from patient
       // self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnVideo), UIBarButtonItem(customView: btnAudio)]
    }
    
    
    
    func theTimer() {
        // self.checkForUnreadMessages()
          //      timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.checkForUnreadMessages), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.refershChatMessage), userInfo: nil, repeats: true)
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        openActionSheetForAttachment()
    }
    
      /*
    func video(sender: UIBarButtonItem) {
        self.logOut()
        self.navigateToCall(isAudio: false)
    }
    
    func audio(sender: UIBarButtonItem) {
        self.logOut()
        self.navigateToCall(isAudio: true)
    }
    
    
    //MARK: WebRTC configuration
  
    func cofigureVideo() {
        QBRTCConfig.mediaStreamConfiguration().videoCodec = .H264
        let videoFormat = QBRTCVideoFormat.init()
        videoFormat.frameRate = 21
        videoFormat.pixelFormat = .format420f
        videoFormat.width = 640
        videoFormat.height = 480
        
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: .front)
        self.videoCapture.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        self.videoCapture.startSession {
            let localView = LocalVideoView.init(withPreviewLayer:self.videoCapture.previewLayer)
            self.stackView.addArrangedSubview(localView)
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
    
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        
        if self.session == nil {
            self.session = session
            handleIncomingCall()
        }
    }
    
    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
        
        if (session as! QBRTCSession).id == self.session?.id {
            if session.conferenceType == QBRTCConferenceType.video {
                //                self.screenShareBtn.isHidden = false
            }
        }
    }
    
    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        
        if session.id == self.session?.id {
            
            self.removeRemoteView(with: userID.uintValue)
            if userID == session.initiatorID {
                self.session?.hangUp(nil)
            }
        }
    }
    
    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
        if (session as! QBRTCSession).id == self.session?.id {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
            nextViewController.currentUser =  self.currentUser
            nextViewController.videoTrack = videoTrack
            nextViewController.userID = userID
            nextViewController.baseSession = session
            nextViewController.session = self.session
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func logOut() {
        QBChat.instance.disconnect { (err) in
            QBRequest .logOut(successBlock: { (r) in
            })
        }
    }
    
    func sessionDidClose(_ session: QBRTCSession) {
        
        if session.id == self.session?.id {
            // self.callBtn.isHidden = false
            //self.logoutBtn.isEnabled = true
            //            self.screenShareBtn.isHidden = true
            //let ids = self.opponets?.map({$0.id})
            
            // for userID in opponentIds {
            let senderInfo = dataUserDefault.object(forKey: "quick_blox_ids") as! Dictionary<String,Any>
            let quickBoxId = senderInfo["quick_blox_id"] as? String
            self.removeRemoteView(with: UInt(quickBoxId!)!)
            //  }
            self.session = nil
        }
    }
    
    //MARK: Helpers
    
    func resumeVideoCapture() {
        // ideally you should always stop capture session
        // when you are leaving controller in any way
        // here we should get its running state back
        if self.videoCapture != nil && !self.videoCapture.hasStarted {
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.videoCapture.startSession(nil)
        }
    }
    
    func removeRemoteView(with userID: UInt) {
        //        self.stackView.isHidden = false
        for view in self.stackView.arrangedSubviews {
            if view.tag == userID {
                self.stackView.removeArrangedSubview(view)
            }
        }
    }
    
    func handleIncomingCall() {
        
        let alert = UIAlertController.init(title: "Incoming video call", message: "Accept ?", preferredStyle: .actionSheet)
        
        let accept = UIAlertAction.init(title: "Accept", style: .default) { action in
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.session?.acceptCall(nil)
        }
        
        let reject = UIAlertAction.init(title: "Reject", style: .default) { action in
            self.session?.rejectCall(nil)
        }
        
        alert.addAction(accept)
        alert.addAction(reject)
        self.present(alert, animated: true)
    }
    
    
    func navigateToCall(isAudio: Bool) {
        self.logOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
        nextViewController.currentUser =  self.currentUser
        nextViewController.isAudio = isAudio
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    */
    //MARK: - Action Sheet
    func  openActionSheetForAttachment(){
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        let galleryActionButton = UIAlertAction(title: "Send Image", style: .default) { action -> Void in
            self.openGallary()
        }
        actionSheetController.addAction(galleryActionButton)
        let videoActionButton = UIAlertAction(title: "Send Video", style: .default) { action -> Void in
            self.openVideos()
            
        }
        actionSheetController.addAction(videoActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //      self.timer.invalidate()
    }
    
    func checkMediaTypeAndAppendOnMessages(tempMessage:Messages){
        
        if !tempMessage.file.isEmpty{
            let url1 : String = tempMessage.file
            let imageExtensions = ["png", "jpg", "gif"]
            //...
            // Iterate & match the URL objects from your checking results
            let url: URL? = NSURL(fileURLWithPath: url1) as URL
            let pathExtention = url?.pathExtension
            if imageExtensions.contains(pathExtention!)
            {
                guard let url = URL(string: tempMessage.file) else{return }
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    
                    let photoItem = JSQPhotoMediaItem(image: image)
                    let newMessage = JSQMessage(senderId: tempMessage.sender_uuid , displayName: tempMessage.author , media: photoItem)
                    self.message.append(newMessage!)
                //    self.collectionView.reloadData()
                }
            }else{
                print("Movie URL: \(String(describing: url))")
                let videoItem = JSQVideoMediaItem(fileURL:  URL(string: tempMessage.file), isReadyToPlay: true)
                let newMessage = JSQMessage(senderId: tempMessage.sender_uuid , displayName: tempMessage.author , media: videoItem)
                self.message.append(newMessage!)
          //      self.collectionView.reloadData()
            }
        }else{
            let newMessage = JSQMessage(senderId: tempMessage.sender_uuid , displayName: tempMessage.author , text: tempMessage.message)
            message.append(newMessage!)
        }
        DispatchQueue.main.async {
            self.finishReceivingMessage()
               self.collectionView.reloadData()
        }
    }
    
    
    func addingMessages(){
        for messageObject in allMessages {
            self.checkMediaTypeAndAppendOnMessages(tempMessage: messageObject)
            
//            if !messageObject.file.isEmpty{
//
//                // let photoItem = JSQPhotoMediaItem(image: UIImage(named: messageObject.file)!)
//
//                let url1 : String = messageObject.file
//                let imageExtensions = ["png", "jpg", "gif"]
//                //...
//                // Iterate & match the URL objects from your checking results
//                let url: URL? = NSURL(fileURLWithPath: url1) as URL
//                let pathExtention = url?.pathExtension
//                if imageExtensions.contains(pathExtention!)
//                {
//
//                     guard let url = URL(string: messageObject.file) else{return }
//                    let data = try? Data(contentsOf: url)
//                    if let imageData = data {
//                        let image = UIImage(data: imageData)
//
//                        let photoItem = JSQPhotoMediaItem(image: image)
//                        let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , media: photoItem)
//                        self.message.append(newMessage!)
//                        self.collectionView.reloadData()
//                    }
//
//                    //                    print("Image URL: \(String(describing: url))")
//                    //                    KingfisherManager.shared.retrieveImage(with: URL(string:messageObject.file)! , options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
//                    //                        print(image ?? "image not found")
//                    //                        let photoItem = JSQPhotoMediaItem(image: image)
//                    //                        let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , media: photoItem)
//                    //                       // self.message.append(newMessage!)
//                    //                        let index = self.message.index(where: {$0.senderId == messageObject.id})
//                    //                        self.message[index!] = newMessage!
//                    //
//                    //                        self.collectionView.reloadData()
//                    //                    })
//                }else
//                {
//                    print("Movie URL: \(String(describing: url))")
//
//                    //    let videoItem = JSQVideoMediaItem(fileURL: DefaultDownloadResponse.destinationURL, isReadyToPlay: true)
//
//                    let videoItem = JSQVideoMediaItem(fileURL:  URL(string: messageObject.file), isReadyToPlay: true)
//                    let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , media: videoItem)
//                    self.message.append(newMessage!)
//                    self.collectionView.reloadData()
//
//                    //                    let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
//                    //                    Alamofire.download(
//                    //                        messageObject.file,
//                    //                        method: .get,
//                    //                        parameters: nil,
//                    //                        encoding: JSONEncoding.default,
//                    //                        headers: nil,
//                    //                        to: destination).downloadProgress(closure: { (progress) in
//                    //                            //progress closure
//                    //                        }).response(completionHandler: { (DefaultDownloadResponse) in
//                    //                          //  print("Temporary URL: \(String(describing: response.temporaryURL))")
//                    //                            let videoItem = JSQVideoMediaItem(fileURL: DefaultDownloadResponse.destinationURL, isReadyToPlay: true)
//                    //                            let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , media: videoItem)
//                    //                            self.message.append(newMessage!)
//                    //                            self.collectionView.reloadData()
//                    //                        })
//
//                    //                    Alamofire.download(messageObject.file).responseData { response in
//                    //                        print("Temporary URL: \(String(describing: response.temporaryURL))")
//                    //                        let videoItem = JSQVideoMediaItem(fileURL: response.temporaryURL, isReadyToPlay: true)
//                    //                                                let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , media: videoItem)
//                    //                                                self.message.append(newMessage!)
//                    //                                                self.collectionView.reloadData()
//                    //                    }
//
//                    //                    KingfisherManager.shared.retrieveImage(with: URL(string:messageObject.file)! , options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
//                    //                        print(image ?? "image not found")
//                    //                        var videoItem = JSQVideoMediaItem(fileURL: image, isReadyToPlay: true)
//                    //                        let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , media: videoItem)
//                    //                        self.message.append(newMessage!)
//                    //                    })
//                }
//            }else{
//                let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , text: messageObject.message)
//                message.append(newMessage!)
//            }
       }
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
   //     dismiss(animated:true, completion: nil) //5

        SVProgressHUD.show()
        Messages.getConversations { (convs) in
            self.threads = convs
            Messages.getParticipants(threads: convs, completed: { (response) in
                self.performSegue(withIdentifier: "goToConvs", sender: nil)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToConvs"){
            SVProgressHUD.dismiss()
            let controller = segue.destination as! ConversationsVC
            controller.conversations = self.threads
        } else if (segue.identifier == "goToMedia") {
            let controller = segue.destination as! MediaContentViewController
            controller.image = selectedMediaImg
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        message.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text))
        self.dismissKeyboard()
        self.finishSendingMessage()
        collectionView.reloadData()
        Messages.sendMessageThread(message: text, thread: currentThread)
        // SS
        //      Messages.markThread(thread: currentThread) {
        //
        //      } // SS
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return message.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let editButton = UIButton(frame:cell.frame)
        editButton.tag = indexPath.row
        editButton.addTarget(self, action: #selector(editButtonTapped), for: UIControlEvents.touchUpInside)
        cell.addSubview(editButton)
        let messageOj = self.message[indexPath.item]
        if messageOj.isMediaMessage{
            print("media message presented")
        }
        //             let messageOj = message[indexPath.item]
        //            let file = messageOj.file
        //            if file.count > 0 {
        //                if file != "null" {
        //                    print("Message is null")
        //                } else {
        //                    cell.avatarImageView.download(from: file)
        //                }
        //            }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return message[indexPath.item]
    }
    
    
    
    //This function will return the messages
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let incomingBubbleMessage = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: blueColor)
        let outgoingBubbleMessage = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: greenColor)
        
        //if message is outgoing from app then is a green left-tail bubble. Else, is a blue right-tail bubble.
        if message[indexPath.row].senderId == self.senderId {
            return outgoingBubbleMessage
        }
        else {
            return incomingBubbleMessage
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // Added By ravi
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, didTapMessageBubbleAt indexPath: IndexPath?) {
        
        let message = self.message[indexPath?.row ?? 0] as? JSQMessage
        if message?.isMediaMessage != nil {
            let mediaItem: JSQMessageMediaData? = message?.media
            if (mediaItem is JSQPhotoMediaItem) {
                print("Tapped photo message bubble!")
                let photoItem = mediaItem as? JSQPhotoMediaItem
                popupImage(photoItem?.image)
            }
            if (mediaItem is JSQVideoMediaItem) {
                print("Tapped photo message bubble!")
                let videoItem = mediaItem as? JSQVideoMediaItem
                popupVideo(fileURL: (videoItem?.fileURL)!)
            }
        }
    }
    
    //    var player = VGPlayer()
    //    var url1 : URL?
    
    func popupVideo(fileURL: URL){
        let videoPlayerVC =  VideoPlayerViewConntrollerViewController()
        videoPlayerVC.fileURL = fileURL
        //     self.navigationController?.pushViewController(videoPlayerVC)
        self.present(videoPlayerVC, animated: false, completion: nil)
    }
    
    func popupImage(_ image: UIImage?) {
        let imageVC = BFRImageViewController(imageSource: [image ?? ""])
        self.present(imageVC!, animated: false, completion: nil)
    }
    
    //******//
    func editButtonTapped(sender: UIButton!) {
        print(sender.tag, message[sender.tag])
        let messageOj =  message[sender.tag]
        if messageOj.isMediaMessage {
            let mediaItem =  messageOj.media
            if mediaItem is JSQPhotoMediaItem {
                let photoItem = mediaItem as! JSQPhotoMediaItem
                selectedMediaImg = photoItem.image //UIImage obtained.
              //  self.performSegue(withIdentifier: "goToMedia", sender: nil)
            }
        }
    }
    
    func refershChatMessage(){
        Messages.getChatMessagesAfterParticularTime(thread: self.currentThread, completed: { (newMessages) in
            debugPrint(newMessages)
            for messageObject in newMessages {
                if(messageObject.sender_uuid != self.senderId) {
                    
                    let result =  self.allMessages.filter { $0.id==messageObject.id }
                    if result.isEmpty {
                        
                        self.allMessages.append(messageObject)
                          self.checkMediaTypeAndAppendOnMessages(tempMessage: messageObject)
                        
                    }
                  
                    
//                    let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , text: messageObject.message)
//                    self.message.append(newMessage!)
//                    DispatchQueue.main.async {
//                        self.finishReceivingMessage()
//                     //   self.collectionView.reloadData()
//                    }
                    // SS
                                      Messages.markThread(thread: messageObject.thread_uuid, completed: {
                                        DispatchQueue.main.async {
                                          self.finishReceivingMessage()
                                          self.collectionView.reloadData()
                                        }
                                      }) // SS
                }
            }
        })
        //      }
    }
    
    
    
    func checkForUnreadMessages(){
        //      DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
        //check for new messages here
        //        SVProgressHUD.dismiss()
        //        SVProgressHUD.show()
        
        Messages.listeningIncomingMessages(thread: self.currentThread, completed: { (newMessages) in
            debugPrint(newMessages)
            for messageObject in newMessages {
                if(messageObject.sender_uuid != self.senderId) {
                    
                    let newMessage = JSQMessage(senderId: messageObject.sender_uuid , displayName: messageObject.author , text: messageObject.message)
                    
                  
                    self.message.append(newMessage!)
                    
                    DispatchQueue.main.async {
                        self.finishReceivingMessage()
                        self.collectionView.reloadData()
                    }
                    // SS
                                      Messages.markThread(thread: messageObject.thread_uuid, completed: {
                                        DispatchQueue.main.async {
                                          self.finishReceivingMessage()
                                          self.collectionView.reloadData()
                                        }
                                      }) // SS
                }
            }
            SVProgressHUD.dismiss()

        })
        //      }
    }
    
    
}

extension SupportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openVideos(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if picker.sourceType == .savedPhotosAlbum{
            let video = info[UIImagePickerControllerMediaURL] as? URL
            
            //            let image = UIImage()
            //
            //            if let thumbnailImage = getThumbnailImage(forUrl: video!) {
            //                print(thumbnailImage)
            //                image = thumbnailImage
            //            }
            
            let mediaItem =  JSQVideoMediaItem(fileURL: video, isReadyToPlay: true) //JSQVideoMediaItem(fileURL: video, isReadyToPlay: true, setThumbnail: image)
            Messages.callAPIForUploadVideo(url: video!, message: "", thread: currentThread)
            let sendMessage = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: mediaItem)
            self.message.append(sendMessage!)
            self.finishSendingMessage()
        }
        else{
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
            let imageData: Data = UIImageJPEGRepresentation(chosenImage, 0.2)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            imgSelected = chosenImage
            strImage = strBase64
            
            //upload at server
            Messages.multipart(image: imgSelected,message: "", thread: currentThread)
            
            let mediaItem = JSQPhotoMediaItem(image:chosenImage )
            mediaItem?.image = UIImage(data:UIImageJPEGRepresentation(chosenImage, 0.2)!)
            
            let sendMessage = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: mediaItem)
            self.message.append(sendMessage!)
            self.finishSendingMessage()
        }
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}
