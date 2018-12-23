//
//  AuthenticationController.swift
//  SampleBit
//
//  Created by Stephen Barnes on 9/14/16.
//  Copyright © 2016 Fitbit. All rights reserved.
//

import SafariServices
import Foundation

protocol AuthenticationProtocol {
    func authorizationDidFinish(_ success :Bool, url:URL)
}

struct NotificationConstants {
    static let launchNotification = "SampleBitLaunchNotification"
}

class AuthenticationController: NSObject, SFSafariViewControllerDelegate {
	let clientID = "22CQMD"//"YOUR_CLIENT_ID_HERE"
	let clientSecret = "11183fea934b788c08ff7e4aa61ac86e"//YOUR_CLIENT_SECRET_HERE"
	let baseURL = URL(string: "https://www.fitbit.com/oauth2/authorize")
    static let redirectURI = "https://vogcalgaryappdeveloper.com/sync-successful/" //YOUR_CLIENT_URI_HERE://"
	let defaultScope = "sleep+settings+nutrition+activity+social+heartrate+profile+weight+location"

	var authorizationVC: SFSafariViewController?
	var delegate: AuthenticationProtocol?
	var authenticationToken: String?

    var tokenURL:URL!
    
    var vc:UIViewController!
    
	init(delegate: AuthenticationProtocol?) {
		self.delegate = delegate
		super.init()
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NotificationConstants.launchNotification), object: nil, queue: nil, using: { [weak self] (notification: Notification) in
			// Parse and extract token
			let success: Bool
			if let token = AuthenticationController.extractToken(notification, key: "#access_token") {
				self?.authenticationToken = token
				NSLog("You have successfully authorized")
				success = true
			} else {
				print("There was an error extracting the access token from the authentication response.")
				success = false
			}

			self?.authorizationVC?.dismiss(animated: true, completion: {
                self?.delegate?.authorizationDidFinish(success,url: (self?.tokenURL)!)
			})
		})
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: Public API

	public func login(fromParentViewController viewController: UIViewController) {
		guard let url = URL(string: "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id="+clientID+"&redirect_uri="+AuthenticationController.redirectURI+"&scope="+defaultScope+"&expires_in=604800") else {
			NSLog("Unable to create authentication URL")
			return
		}

        vc = viewController
        
		let authorizationViewController = SFSafariViewController(url: url)
		authorizationViewController.delegate = self
		authorizationVC = authorizationViewController
		viewController.present(authorizationViewController, animated: true, completion: nil)
	}

	public static func logout() {
		// TODO
	}

	private static func extractToken(_ notification: Notification, key: String) -> String? {
		guard let url = notification.userInfo?[UIApplicationLaunchOptionsKey.url] as? URL else {
			NSLog("notification did not contain launch options key with URL")
			return nil
		}

		// Extract the access token from the URL
		let strippedURL = url.absoluteString.replacingOccurrences(of: AuthenticationController.redirectURI, with: "")
		return self.parametersFromQueryString(strippedURL)[key]
	}

	// TODO: this method is horrible and could be an extension and use some functional programming
	private static func parametersFromQueryString(_ queryString: String?) -> [String: String] {
		var parameters = [String: String]()
		if (queryString != nil) {
			let parameterScanner: Scanner = Scanner(string: queryString!)
			var name:NSString? = nil
			var value:NSString? = nil
			while (parameterScanner.isAtEnd != true) {
				name = nil;
				parameterScanner.scanUpTo("=", into: &name)
				parameterScanner.scanString("=", into:nil)
				value = nil
				parameterScanner.scanUpTo("&", into:&value)
				parameterScanner.scanString("&", into:nil)
				if (name != nil && value != nil) {
					parameters[name!.removingPercentEncoding!]
						= value!.removingPercentEncoding!
				}
			}
		}
		return parameters
	}

	// MARK: SFSafariViewControllerDelegate

	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if (tokenURL != nil) {
            delegate?.authorizationDidFinish(false,url: tokenURL)
        }else{
            delegate?.authorizationDidFinish(false,url: URL(string:"www.google.com")!)
        }
	}
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL){
        tokenURL = URL
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        // parse url
        let strURL = tokenURL.absoluteString
        
        let arrayToken = strURL.components(separatedBy: "#")
        
        var access_token = ""
        var user_id = ""
        
        if arrayToken.count > 1{
            print("strURL: \(arrayToken[1])")
            let arrayElement = arrayToken[1].components(separatedBy: "&")
            
            for item in arrayElement {
                let arrayKeyAndValue = item.components(separatedBy: "=")
                if arrayKeyAndValue.count > 1{
                    if arrayKeyAndValue[0] == "access_token" {
                        access_token = arrayKeyAndValue[1]
                    }
                    if arrayKeyAndValue[0] == "user_id" {
                        user_id = arrayKeyAndValue[1]
                    }
                }
            }
        }
        
        if access_token.charactersArray.count > 0 && user_id.charactersArray.count > 0 {
            self.vc.dismiss(animated: true, completion: {
                self.delegate?.authorizationDidFinish(false,url: self.tokenURL)
            })
        }
    }    
}
