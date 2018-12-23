
//
//  ChatObject.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-24.
//  Edited by Jorge Gomez
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class Messages{
    
    private var _id: String
    private var _sender_uuid: String
    private var _thread_uuid: String
    private var _created_at: String
    private var _message: String
    private var _author: String
    private var _file: String
    
    //Messages constructor
    
    init(id: String, sender_uuid: String, thread_uuid: String, message: String,
         created_at: String, author: String, file: String ){
        self._id = id
        self._sender_uuid = sender_uuid
        self._thread_uuid = thread_uuid
        self._message = message
        self._created_at = created_at
        self._author = author
        self._file = file
    }
    
    var id: String{
        if(_id != ""){
            return _id
        } else {
            return ""
        }
    }
    
    var file: String {
        return _file
    }
    
    var created_at: String{
        return _created_at
    }
    
    var sender_uuid: String {
        return _sender_uuid
    }
    
    var thread_uuid: String {
        return _thread_uuid
    }
    
    var message: String {
        
        return _message
    }
    
    var author: String {
        return _author
    }
    
    
    //GET user threads
    static func getConversations(completed: @escaping ([String]) -> Void){
        
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token")
        var threads = [String]()
        Alamofire.request("\(MESSAGES_THREAD)?auth_token=\(token!)").responseJSON { (response) in
            debugPrint(response)
            
            if let result = response.value as? Dictionary<String,[String]> {
                threads = result["threads"]!
            }
            completed(threads)
        }
    }
    
    //GET all thread messages
    static func getThreadMessages(thread:String, completed: @escaping ([Messages]) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        let parameters: Parameters = [
            "thread_uuid": thread,
            "auth_token": token
        ]
        var messagesArray = [Messages]()
        
        Alamofire.request("\(ALL_MESSAGES)", parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            
            if let result = response.value as? Dictionary<String,[Dictionary<String,Any>]> {
                let messages = result["messages"]
                for message in messages!.reversed() {
                    
                    let messageId = message["id"] as! String
                    let messageSender = message["sender_uuid"] as! String
                    let messageThread = message["thread_uuid"] as! String
                    var  messageText: String = ""
                    if let strMsg = message["message"] as? String{
                        messageText = strMsg
                    }
                    let messageDate = message["created_at"] as! String
                    let messageAuthor = message["author"] as! String
                    var messageFile: String = ""
                    if let strFile = message["file"] as? String{
                        messageFile = strFile
                    }
                    let newMessage = Messages(id: messageId, sender_uuid: messageSender, thread_uuid: messageThread, message: messageText, created_at: messageDate, author: messageAuthor, file: messageFile)
                    messagesArray.append(newMessage)
                }
            }
            completed(messagesArray)
        }
    }
    
    // get unread message
    static func getUnreadMessages(thread:String, completed: @escaping ([Messages]) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        let parameters: Parameters = [
            "thread_uuid": thread,
            "auth_token": token
        ]
        var messagesArray = [Messages]()
        
        Alamofire.request("\(NEW_MESSAGES)", parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            
            if let result = response.value as? Dictionary<String,[Dictionary<String,Any>]> {
                let messages = result["messages"]
                for message in messages!.reversed() {
                    
                    let messageId = message["id"] as! String
                    let messageSender = message["sender_uuid"] as! String
                    let messageThread = message["thread_uuid"] as! String
                    var  messageText: String = ""
                    if let strMsg = message["message"] as? String{
                        messageText = strMsg
                    }
                    let messageDate = message["created_at"] as! String
                    let messageAuthor = message["author"] as! String
                    var messageFile: String = ""
                    if let strFile = message["file"] as? String{
                        messageFile = strFile
                    }
                    let newMessage = Messages(id: messageId, sender_uuid: messageSender, thread_uuid: messageThread, message: messageText, created_at: messageDate, author: messageAuthor, file: messageFile)
                    messagesArray.append(newMessage)
                }
            }
            completed(messagesArray)
        }
    }
    
    //GET thread participants
    static func getParticipants(threads:[String], completed: @escaping ([Dictionary<String,Any>]) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        var participants = [Dictionary<String,Any>]()
        
        var i=0
        
        for thread in threads {
            let parameters: Parameters = [
                "thread_uuid": thread,
                "auth_token": token
            ]
            
            Alamofire.request("\(MESSAGE_PARTICIPANTS)", parameters: parameters).responseJSON { (response) in
                i = i + 1
                if let result = response.value as? Dictionary<String,[Dictionary<String,Any>]> {
                    participants = result["participants"]!
                }
                if i == threads.count {
                    completed(participants)
                }
            }
        }
    }
    
    
    
    //POST new message to the backend.
    static func sendMessageThread(message: String, thread: String){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
       let doctorId = dataUserDefaults.object(forKey: "doctor_user_id") as! String

        
        let parameters: Parameters = [
            "thread_uuid": thread,
            "message": message,
            "auth_token": token,
            "doctor_id": doctorId
        ]
        
        Alamofire.request("\(SEND_MESSAGE)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            
        })
        
    }
    
    //GET UNREAD MESSAGES
    static func listeningIncomingMessages(thread: String, completed: @escaping ([Messages]) -> Void){
        let dataUserDefault = UserDefaults.standard
        let token = dataUserDefault.object(forKey: "auth_token") as! String
        
        let parameters: Parameters = [
            "thread_uuid": thread,
            "auth_token": token
        ]
        
        var messagesArray = [Messages]()
        
        Alamofire.request("\(NEW_MESSAGES)", parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            
            if let result = response.value as? Dictionary<String,[Dictionary<String,Any>]> {
                let messages = result["messages"]
                for message in messages!.reversed() {
                    
                    //            let messageId = message["id"] as! String
                    //            let messageSender = message["sender_uuid"] as! String
                    //            let messageThread = message["thread_uuid"] as! String
                    //            let messageText = message["message"] as! String
                    //            let messageDate = message["created_at"] as! String
                    //            let messageAuthor = message["author"] as! String
                    //
                    //            let newMessage = Messages(id: messageId, sender_uuid: messageSender, thread_uuid: messageThread, message: messageText, created_at: messageDate, author: messageAuthor)
                    //            messagesArray.append(newMessage)
                    
                    let messageId = message["id"] as! String
                    let messageSender = message["sender_uuid"] as! String
                    let messageThread = message["thread_uuid"] as! String
                    var  messageText: String = ""
                    if let strMsg = message["message"] as? String{
                        messageText = strMsg
                    }
                    let messageDate = message["created_at"] as! String
                    let messageAuthor = message["author"] as! String
                    var messageFile: String = ""
                    if let strFile = message["file"] as? String{
                        messageFile = strFile
                    }
                    let newMessage = Messages(id: messageId, sender_uuid: messageSender, thread_uuid: messageThread, message: messageText, created_at: messageDate, author: messageAuthor, file: messageFile)
                    messagesArray.append(newMessage)
                }
            }
            completed(messagesArray)
        }
    }
    
    //Ravi
    //get the chat messages after particular time
    static func getChatMessagesAfterParticularTime(thread: String, completed: @escaping ([Messages]) -> Void){
        let dataUserDefault = UserDefaults.standard
        guard let token = dataUserDefault.object(forKey: "auth_token") as? String else{
            return
        }
        
        let parameters: Parameters = [
            "user_uuid": thread,
            "auth_token": token,
            "time" : ""
        ]
        
        var messagesArray = [Messages]()
        
        Alamofire.request("\(REFERSH_CHAT_MESSAGES)", parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            
            if let result = response.value as? Dictionary<String,[Dictionary<String,Any>]> {
                let messages = result["messages"]
                for message in messages!.reversed() {
                    
                    //            let messageId = message["id"] as! String
                    //            let messageSender = message["sender_uuid"] as! String
                    //            let messageThread = message["thread_uuid"] as! String
                    //            let messageText = message["message"] as! String
                    //            let messageDate = message["created_at"] as! String
                    //            let messageAuthor = message["author"] as! String
                    //
                    //            let newMessage = Messages(id: messageId, sender_uuid: messageSender, thread_uuid: messageThread, message: messageText, created_at: messageDate, author: messageAuthor)
                    //            messagesArray.append(newMessage)
                    
                    let messageId = message["id"] as! String
                    let messageSender = message["sender_uuid"] as! String
                    let messageThread = message["thread_uuid"] as! String
                    var  messageText: String = ""
                    if let strMsg = message["message"] as? String{
                        messageText = strMsg
                    }
                    let messageDate = message["created_at"] as! String
                    let messageAuthor = message["author"] as! String
                    var messageFile: String = ""
                    if let strFile = message["file"] as? String{
                        messageFile = strFile
                    }
                    let newMessage = Messages(id: messageId, sender_uuid: messageSender, thread_uuid: messageThread, message: messageText, created_at: messageDate, author: messageAuthor, file: messageFile)
                    messagesArray.append(newMessage)
                }
            }
            completed(messagesArray)
        }
    }
    
    
    //MARK UNREAD MESSAGES AS READ
    static func markThread(thread: String, completed: @escaping DownloadComplete){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        let parameters: Parameters = [
            "thread_uuid": thread,
            "auth_token": token
        ]
        
        Alamofire.request("\(MARK_THREAD_AS_READ)", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            
            completed()
        })
    }
    
    
    static func allUnreadMessages(completed: @escaping ([Dictionary<String,String>]) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        
        let parameters: Parameters = [
            "auth_token": token
        ]
        
        var messages: [Dictionary<String,String>] = []
        Alamofire.request("\(UNREAD_MESSAGES)", parameters: parameters).responseJSON { (response) in
            
            debugPrint(response)
            if let result = response.value as? Dictionary<String,Any> {
                if let newMessages = result["messages"] as? [Dictionary<String,String>] {
                    messages = newMessages
                }
            }
            completed(messages)
        }
        
    }
    
    static func multipart(image: UIImage,message: String, thread: String){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        let doctorId = dataUserDefaults.object(forKey: "doctor_user_id") as! String

        var  parameters: [String : String]?
        parameters = [
            "thread_uuid": thread,
            "message": message,
            "auth_token": token,
        "doctor_id": doctorId
        ]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if  let imageData = UIImageJPEGRepresentation(image,0.3){
                    let strName  = String(format: "%@.jpg","001")
                    multipartFormData.append(imageData, withName: "attached_file", fileName: strName, mimeType: "image/jpeg")
                }
                for (key, val) in parameters! {
                    multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: "\(SEND_MESSAGE)",method: .post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch(response.result) {
                        case .success(_):
                            print("succsssss")
                            if response.result.value != nil{
                                print(response.result.value as Any)
                            }
                            break
                        case .failure(_):
                            print("fail")
                            print(response.result.error as Any)
                            break
                        }
                    }
                case .failure(_):
                    break
                }
        }
        )
    }
    
    static func callAPIForUploadVideo(url: URL, message: String, thread: String){
        let dataUserDefaults = UserDefaults.standard
        let token = dataUserDefaults.object(forKey: "auth_token") as! String
        let doctorId = dataUserDefaults.object(forKey: "doctor_user_id") as! String

        var  parameters: [String : String]?
        parameters = [
            "thread_uuid": thread,
            "message": message,
            "auth_token": token,
        "doctor_id": doctorId
        ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(url, withName: "attached_file", fileName: "video.mp4", mimeType: "video/mp4")
            for (key, val) in parameters! {
                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(SEND_MESSAGE)", encodingCompletion: { (result) in
            // code
            switch result {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.validate().responseJSON {
                    response in
                    print("result----\(response.result)")
                    if response.result.isFailure {
                        debugPrint(response)
                    } else {
                        let result = response.value as! NSDictionary
                        print(result)
                    }
                }
            case .failure(let encodingError):
                NSLog((encodingError as NSError).localizedDescription)
            }
        })
    }
    
    static func getPatientTermsAndCondition( completed: @escaping (String) -> Void){
        let parameters: Parameters = [:]
        Alamofire.request("\(Get_patient_privacy_policy)", parameters: parameters).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            if response.result.isSuccess{
                if let patientProfileJSON = JSON(response.value ?? "")["page"].string{
                    completed(patientProfileJSON)
                }
            }
        }
        )}
    
    
    static func getPatientPrivacyPolicy( completed: @escaping (String) -> Void){
        let parameters: Parameters = [:]
        Alamofire.request("\(Get_patient_privacy_policy)", parameters: parameters).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            if response.result.isSuccess{
                if let patientProfileJSON = JSON(response.value ?? "")["page"].string{
                    completed(patientProfileJSON)
                }
            }
        }
        )}
    
    static func getPatientFAQ( completed: @escaping (String) -> Void){
        let parameters: Parameters = [:]
        Alamofire.request("\(Get_faq)", parameters: parameters).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            if response.result.isSuccess{
                if let patientProfileJSON = JSON(response.value ?? "")["page"].string{
                    completed(patientProfileJSON)
                }
            }
        }
        )}
    
    
    
    
    // extended functionality in doctor application
    
    //GET  document
    //  http://cardiai.ca/api/doctor/patient/documents?patient_pid=1&document_type=all
    static func getDoucments(documentType:String, completed: @escaping ([DocumentsModel]) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let patientId = dataUserDefaults.object(forKey: "patientId") as! String
        let parameters: Parameters = [:]
        Alamofire.request("\(Get_documents)?patient_pid=\(patientId)&document_type=\(documentType)", parameters: parameters).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            if response.result.isSuccess{
                if let doumentsInJSON = JSON(response.value ?? "")["data"]["patient_documents"].arrayObject{
                    let doumentList =  DocumentsModel.initializedModelList(listData: doumentsInJSON)
                    completed(doumentList)
                }
            }
        }
        )}
    
    // let Get_Patient_Profile = "\(SERVER_API)api/doctor/patient/profile"
    
    static func getPatientProfile( completed: @escaping (PatientProfileModel) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let patientId = dataUserDefaults.object(forKey: "patientId") as! String
        let parameters: Parameters = [:]
        Alamofire.request("\(Get_Patient_Profile)?patient_pid=\(patientId)", parameters: parameters).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            if response.result.isSuccess{
                if let patientProfileJSON = JSON(response.value ?? "")["data"]["patient_profile"].dictionary{
                    let patientProfile =  PatientProfileModel.initialize(data:JSON(response.value ?? "")["data"]["patient_profile"])
                    completed(patientProfile)
                }
            }
        }
        )}
    
    static func getMeditations(pid:String, completed: @escaping (String) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let patientId = dataUserDefaults.object(forKey: "patientId") as! String
        //   var threads = [String]()
        Alamofire.request("\(Get_Meditations)?patient_pid=\(patientId)").responseJSON { (response) in
            debugPrint(response)
            let data =   JSON(response.value ?? "").dictionaryValue["data"]!["patient_profile"].stringValue
            //            if let result = response.value as? Dictionary<String,[String]> {
            //                threads = result["threads"]!
            //            }
            completed(data)
        }
    }
    
    static func getPatientChartData( data:String, year: String,  completed: @escaping (PatientCharDataModel) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let patientId = dataUserDefaults.object(forKey: "patientId") as! String
        
        let parameters: Parameters = [:]
        Alamofire.request("\(Get_get_patient_data)?date=&pid=\(patientId)&year=\(year)&date=\(data)", parameters: parameters).responseJSON(completionHandler: { (response) in
            debugPrint(response)
            if response.result.isSuccess{
                if let patientProfileJSON = JSON(response.value ?? "").dictionary{
                    let patientCharData =  PatientCharDataModel.initialize(data:JSON(response.value ?? ""))
                    completed(patientCharData)
                }
            }
        }
        )}
//    Get_get_login_authorization
//    http://cardiai.ca/api/qardiyo/patient/login?user_id=7&authorization_code=123456
//        ?user_id=7&authorization_code=123456
    
    
    
    static func getPatientAuthorizationByPassword(password:String, completed: @escaping (String) -> Void){
        let dataUserDefaults = UserDefaults.standard
        let patientId = dataUserDefaults.object(forKey: "patientId") as! String
        //   var threads = [String]()
        Alamofire.request("\(Get_get_login_authorization)?user_id=\(patientId)&authorization_code=\(password)").responseJSON { (response) in
            debugPrint(response)

            let data =   JSON(response.value ?? "").dictionaryValue["status"]?.stringValue
            //            if let result = response.value as? Dictionary<String,[String]> {
            //                threads = result["threads"]!
            //            }
            completed(data ??  "")
        }
    }

    
}
