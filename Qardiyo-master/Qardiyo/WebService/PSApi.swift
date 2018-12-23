//
//  Api.swift


import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView


// MARK: - Api Results
enum ApiResult<Value> {
        case success(value: Value)
        case failure(error: NSError)

        init(_ f: () throws -> Value) {
                do {
                        let value = try f()
                        self = .success(value: value)
                } catch let error as NSError {
                        self = .failure(error: error)
                }
        }

        @discardableResult
        func unwrap() throws -> Value {
                switch self {
                case .success(let value):
                        return value
                case .failure(let error):
                        throw error
                }
        }
}

enum ChatErrorCode: Int {
        case contactUserIsNotFound = 10
        case contactUnableToAddYourself = 21
        case chatAssingOtherMemberBeManager = 34
}

// MARK: - Endpoints
enum Endpoint {

        // These cases use for testing purpose only
        case  pendingMessages(time: String)
        case signupdiscard
        case changemobilenumber
        case downloadFile(chatId: String, fileId: String)

        case getTest
        case deleteTest
        case putTest


        var method: Alamofire.HTTPMethod {
                switch self {
                case .changemobilenumber, .signupdiscard, .pendingMessages, .downloadFile:
                        return .post
                case .getTest:
                        return .get
                case  .deleteTest:
                        return .delete
                case  .putTest:
                        return .put

                }
        }

        var path: String {
                switch self {




                case .pendingMessages(let time): return "chats/\(time)/messages/pending"
                //    case .pendingMessages(let time): return "chats/\(time)/messages/pending"
                case  .signupdiscard: return "signupdiscard"
                case .changemobilenumber: return "changemobilenumber"
                        //***//
                        // case .login: return "login"

                case .downloadFile(let chatId, let fileId): return "storage/\(chatId)/\(fileId)"

                case .getTest:return "getTest"
                case .deleteTest:return "deleteTest"
                case .putTest:return "putTest"
                }
        }

        var encoding: Alamofire.ParameterEncoding {

                switch self {
                case .changemobilenumber, .signupdiscard:
                        return JSONEncoding.default
                case .pendingMessages, .downloadFile, .getTest, .deleteTest, .putTest:
                        return URLEncoding.default

                }
        }
}


// MARK: -  Api
class PSApi {
        // MARK: - Public Methods
        static func apiRequestWithEndPoint(_ endpoint: Endpoint, params: [String: AnyObject]? = nil, isShowAlert : Bool, controller:UIViewController, isNeedToken: Bool = true, response: @escaping (DataResponse<JSON>) -> Void) {

                // start loading indicator
                DispatchQueue.main.async {
                        let activityData = ActivityData()
                        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
                }
                var url : URL?
                url = URL(string:baseURLLatest)?.URLByAppendingEndpoint(endpoint)
                let finalParams = (params == nil) ? [String: AnyObject]() : params!
                var header: HTTPHeaders = HTTPHeaders()
                header = ["Content-Type":"application/json"]
                if isNeedToken {
                        guard let token = UserDefaults.standard.getAuthenticationToken() else {
                                debugPrint("Token not set")
                                return
                        }
                        header = ["Token": token]
                        debugPrint("Token: \(token)")
                }
                // These log added by Ravi
                print("API Requrest URL========> \(String(describing: url?.absoluteString ) ?? "")")
                print ("parameter = \(finalParams)")
                print ("header = \(header)")
                print ("method = \(endpoint.method.rawValue)")

                do {
                        let jsonData = try JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted)
                        print ("method = \(String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Test")")
                } catch {
                        print("Error")
                }


                let manager = Alamofire.SessionManager.default
                manager.session.configuration.timeoutIntervalForRequest = 120

                manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
                        print ("\n")
                        print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
                        print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
                        print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
                        print("Request===> \(responseData.request!)")
                        print("Response data:===> \(JSON(responseData.data!) )")
                        print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
                        print ("\n")

                        DispatchQueue.main.async {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        }
                        switch responseData.result {
                        case .success:

                                //                                switch responseData.value!["StatusCode"].rawString{
                                //                                case ResponseStatusCode.success.rawValue:
                                //                                                response (responseData)
                                //                                case ResponseStatusCode.error.rawValue:
                                //                                                if  isShowAlert{
                                //                                                        PSUtility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                //                                        }
                                //                                case ResponseStatusCode.sessionExpired.rawValue:
                                //                                                if  isShowAlert{
                                //                                                        PSUtility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                //                                                }
                                //                                                PSUtility.logoutAction(controller:controller)
                                //                                }

                                if  (responseData.value!["StatusCode"] == "00"){
                                        response (responseData)
                                        if responseData.value!["ResponseData"].dictionary != nil{
                                                // response (responseData)
                                        }
                                }else if (responseData.value!["StatusCode"] == "03"){
                                        if  isShowAlert{
                                               Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                        }

                                }else if (responseData.value!["StatusCode"] == "04"){
                                        if  isShowAlert{
                                               Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                        }
                                        Utility.logoutAction(controller:controller)
                                }else{
                                        print("")

                                }
                        case .failure(let error):
                                print (error)
                                if  isShowAlert{
                                        Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                }
                                break
                        }
                }
        }
}

