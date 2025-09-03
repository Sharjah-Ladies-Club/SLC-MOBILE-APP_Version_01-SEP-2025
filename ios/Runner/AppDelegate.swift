import UIKit
import Flutter
import Firebase
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var backgroundSessionCompletionHandler = [String: (()->Void)]()
    var resultData = ""

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDUEL9lnf4rvHJb1CtEzRV_yk1socYxR7s")
    GeneratedPluginRegistrant.register(with: self)
    self.registerForPushNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func getBase(result: FlutterResult) {
        result(String(resultData))
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                guard granted else { return }
                 self.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
       
    }

    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                    UNUserNotificationCenter.current().delegate = self
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                })
            }
        } else {
              let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
   // @available(iOS 10, *)
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
       // super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
    }

    
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }


}
