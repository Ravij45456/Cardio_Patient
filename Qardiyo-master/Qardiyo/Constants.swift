//
//  Constants.swift
//  Qardiyo
//
//  Created by Jorge Alejandro Gomez on 2017-01-10.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import Foundation


//let SERVER_API = "https://emr.qardiyo.com/"
//let SERVER_API = "http://35.182.195.109/"
let SERVER_API = "http://cardiai.ca/"


//SURVEYS
let SURVEY_URL = "\(SERVER_API)api/qardiyo/survey/inbox"
let SUBMIT_SURVEY = "\(SERVER_API)api/qardiyo/survey/submit"
let GET_COMPLETED_SURVEY = "\(SERVER_API)api/qardiyo/survey/completed/answers"
let GET_ALL_COMPLETED_SURVEYS = "\(SERVER_API)api/qardiyo/survey/completed"
let GET_EXTRA_QUESTIONS = "\(SERVER_API)api/qardiyo/survey/extraQuestions"

//TIPS AND FAQ
let FAQ_URL = "\(SERVER_API)api/qardiyo/faq/all?"
let TIPS_URL = "\(SERVER_API)api/qardiyo/tip/all?"

// for terms and condtion, faq
let Get_patient_privacy_policy =  "\(SERVER_API)api/doctor/get_patient_pages?page=toc"
let Get_faq =  "\(SERVER_API)api/doctor/get_patient_pages?page=faq"

//let Get_doctor_page_faq = "\(SERVER_API)api/doctor/get_doctor_pages?page=faq"


//AUTHENTICATION
let AUTH_URL = "\(SERVER_API)api/qardiyo/authenticate?"
let AUTH_PASSWORD_URL = "\(SERVER_API)api/qardiyo/authenticate/"

//HEART RATE
let HEART_RATE_SUBMIT = "\(SERVER_API)api/qardiyo/status/submit"
let HEART_RATE_GET = "\(SERVER_API)api/qardiyo/status/history"

//MESSAGES
let MESSAGES_THREAD = "\(SERVER_API)api/qardiyo/messages/thread/mine"
let SEND_MESSAGE = "\(SERVER_API)api/qardiyo/messages/thread/message/send"
let ALL_MESSAGES = "\(SERVER_API)api/qardiyo/messages/thread/message/all"
let MESSAGE_PARTICIPANTS = "\(SERVER_API)api/qardiyo/messages/thread/participants"
let NEW_MESSAGES = "\(SERVER_API)api/qardiyo/messages/thread/message/unread"
let MARK_THREAD_AS_READ = "\(SERVER_API)api/qardiyo/messages/thread/setRead"
let UNREAD_MESSAGES = "\(SERVER_API)api/qardiyo/messages/unread"
//Ravi
let REFERSH_CHAT_MESSAGES = "\(SERVER_API)api/qardiyo/messages/refresh/chat"

//USER PROFILE
let USER_PROFILE = "\(SERVER_API)api/qardiyo/user/me"
let DEVICE_TOKEN = "\(SERVER_API)api/qardiyo/user/me/device/register/ios"
let UNREGISTER_TOKEN = "\(SERVER_API)api/qardiyo/user/me/device/unregister/ios"
let CHANGE_PASSWORD = "\(SERVER_API)api/qardiyo/user/me/changepassword"

//SYNC
let SYNC_URL = "\(SERVER_API)api/qardiyo/steps/submit"

//This will let me know when the download is completed.
typealias DownloadComplete = () -> ()

let username_keychain = "username_keychain"

let first_time_login = "first_time_login"




// New addtion on more section
let Get_Meditations = "\(SERVER_API)api/doctor/patient/meditations"
let Get_Patient_Profile = "\(SERVER_API)api/doctor/patient/profile"
let Get_documents = "\(SERVER_API)api/doctor/patient/documents"
//***//

//For chart
let Get_get_patient_data = "\(SERVER_API)api/doctor/get_patient_data"
// check valid credencials

 let Get_get_login_authorization = "\(SERVER_API)api/qardiyo/patient/login"


