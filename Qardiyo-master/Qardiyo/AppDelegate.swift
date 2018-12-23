//
  //
//  AppDelegate.swift
//  Qardiyo
//
//  Created by Munib Rahman on 2016-10-22.
//  Edited by Jorge Gomez.
//  Copyright © 2016 Vog Calgary App Developer Inc. All rights reserved.
//



import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Quickblox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
    var window: UIWindow?
    var flag: Int!
    var viewController = ViewController()
    var fromMainMenu = false
    var timer: Timer!
    var player: AVAudioPlayer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        QBSettings.applicationID = 69950
        QBSettings.authKey = "JT--fQS9Yy-mWCH"
        QBSettings.authSecret = "UbYs8gQEccdAvFw"
        QBSettings.accountKey = "Rdc5kwa-AjfSpAzcfx-"
        QBSettings.autoReconnectEnabled = true
        IQKeyboardManager.sharedManager().enable = true
        flag = 0
        self.window?.makeKeyAndVisible()
    
        registerForPushNotifications(application: application)
        application.applicationIconBadgeNumber = 0
        
        let dataUserDefaults = UserDefaults.standard
        if (dataUserDefaults.object(forKey: "autoLogin") != nil){
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "goToTabBar")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        }
        

        
        return true
   }
  
   func registerForPushNotifications(application: UIApplication){
    let notificationSettings = UNUserNotificationCenter.current()
    notificationSettings.requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
      if(success){
        
        application.registerForRemoteNotifications()
      }
      
    }
   }
  
       // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {  
      
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        // Print it to console
        print("APNs device token: \(deviceTokenString)")

        // Persist it in your backend in case it's new
        let dataUserDefaults = UserDefaults.standard
        dataUserDefaults.set(deviceToken, forKey: "deviceToken")
        dataUserDefaults.set(deviceTokenString, forKey: "deviceTokenString")
        
        let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString
        let subscription = QBMSubscription()
        subscription.notificationChannel = .APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        QBRequest.createSubscription(subscription, successBlock: { response, objects in
        }, errorBlock: { response in
        })
      
    }

    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {  
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }


    func applicationWillResignActive(_ application: UIApplication) {
      
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if ((device != nil) && (device?.hasTorch)!) {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureTorchMode.on) {
                    self.viewController.pause()
                } else {

                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
  
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallVC") as! CallViewController
////        nextViewController.currentUser =  self.currentUser
////        nextViewController.videoTrack = videoTrack
////        nextViewController.userID = userID
////        nextViewController.baseSession = session
////        nextViewController.session = self.session
//        if var topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            topController.present(nextViewController, animated: true, completion: nil)
        
        //UIApplication.shared.applicationIconBadgeNumber = 5
   // }
    }
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // This statement return by Ravi
        return
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.dismiss(animated: false, completion: nil)
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//
//                print("topController: \(topController)")
//                if topController is TabBarController {
//                    topController.dismiss(animated: false, completion: nil)
//                }
//            }
            
            // topController should now be your topmost view controller
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
      application.applicationIconBadgeNumber = 0
    }
  

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //application.applicationIconBadgeNumber = 0
        
        let vc = Utility.getCurrentViewController()
        if (vc is ViewController){
          self.viewController.resume()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.viewController.stopCameraCapture()
        let dataUserDefault = UserDefaults.standard
        dataUserDefault.set(nil, forKey: "weigth")
        dataUserDefault.set(nil, forKey: "bpDIA")
        dataUserDefault.set(nil, forKey: "bpSYS")
        dataUserDefault.set(nil, forKey: "General")
        dataUserDefault.set(nil, forKey: "Resting")
        dataUserDefault.set(nil, forKey: "PreExercise")
        dataUserDefault.set(nil, forKey: "PostExercise")
        dataUserDefault.set(nil, forKey: "MaxHeartRate")
        dataUserDefault.set(nil, forKey: "additionalInfo")
        dataUserDefault.set(nil, forKey: "avgPulse")
        dataUserDefault.set(nil, forKey: "dateTime")
        dataUserDefault.set(nil, forKey: "weigth")
        dataUserDefault.set(nil, forKey: "bpDIA")
        dataUserDefault.set(nil, forKey: "bpSYS")
        //dataUserDefault.set(nil, forKey: "auth_token")
//        dataUserDefault.set(nil, forKey: "sender")
//        dataUserDefault.set(nil, forKey: "receiver")
      
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
  
    func playSound() {
        guard let url = Bundle.main.url(forResource: "telephone", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint:AVMediaTypeAudio)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.numberOfLoops = 5
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data stack
  
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Qardiyo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

let ad = UIApplication.shared.delegate as! AppDelegate
@available(iOS 10.0, *)
let context = ad.persistentContainer.viewContext







