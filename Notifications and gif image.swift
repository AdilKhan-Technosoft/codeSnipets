//
//  ViewController.swift
//  Push Notification
//
//  Created by Adil Anjum Khan on 23/06/2023.
//

import UIKit
import ImageIO
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var myGiffImage: UIImageView!
    var isNotificationEnabled:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadGif()
        checkForPermission()
    }
    
    func checkForPermission()
    {
        let notification=UNUserNotificationCenter.current()
        notification.getNotificationSettings { settings in
            switch settings.authorizationStatus
            {
            case .authorized:
                self.isNotificationEnabled=true
                print("Permision provided !!")
            case .denied:
                self.isNotificationEnabled=false
            case .notDetermined:
                notification.requestAuthorization(options:[.alert,.sound], completionHandler: { didAllow, error in
                    if didAllow
                    {
                        self.isNotificationEnabled=true
                    }
                    else
                    {
                        self.isNotificationEnabled=false
                    }
                })
            default:
                self.isNotificationEnabled=false
            }
            notification.delegate = self
        }
    }
    
    
    
    func genrateNotification(tittle:String)
    {
        let notification=UNUserNotificationCenter.current()
        let id = "sendBtnNotification"
        let body = "A genral notification to test notification in IOS functionality"
        let content=UNMutableNotificationContent()
        content.title = tittle
        content.body = body
        content.sound = .default
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(1))
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        let request=UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        print(request)
//        notification.removePendingNotificationRequests(withIdentifiers: [id])
        notification.add(request) { error in
            if let error = error {
                print("Error scheduling local notification: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled successfully")
            }
        }
        
    }
    
    func loadGif() {
        if let gifPath = Bundle.main.path(forResource: "bell", ofType: "gif") {
            if let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) {
                let gifOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                if let gifSource = CGImageSourceCreateWithData(gifData as CFData, gifOptions) {
                    let gifCount = CGImageSourceGetCount(gifSource)
                    var images: [UIImage] = []
                    
                    for i in 0..<gifCount {
                        if let image = CGImageSourceCreateImageAtIndex(gifSource, i, nil) {
                            images.append(UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up))
                        }
                    }
                    
                    myGiffImage.animationImages = images
                    myGiffImage.animationDuration = TimeInterval(gifCount) * 0.05
                    myGiffImage.startAnimating()
                }
            }
        }
    }
    
    @IBAction func addNotification(_ sender: UIButton) {
        showAllert(title: "Genrate Local Notification", message: "Place some text to genrate a local notification with it")
    }
    
    
    private func showAllert(title:String,message:String)
     {
         var txtFieldOfAddButton:UITextField?
         let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         
         allert.addTextField { txtField in
             txtField.placeholder="Enter the text here..."
             txtFieldOfAddButton=txtField
         }
         let action=UIAlertAction(title: "Genrate", style: .default) { confirmationButton in
             if(txtFieldOfAddButton?.text=="")
             {
                 self.presentingViewController?.dismiss(animated: false, completion: nil)
                 self.displayErrorAlert(errorMessage: "Must enter some text to genrate notification")
             }
             else
             {
                 self.genrateNotification(tittle: (txtFieldOfAddButton?.text!)!)
             }
         }
         allert.addAction(action)
         
         self.present(allert, animated: true, completion:{
             allert.view.superview?.isUserInteractionEnabled = true
             allert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
         })
     }
    
    //MARK:- Dismissing keyboard and allerts on tap gestures
      
      @objc func dismissOnTapOutside(){
          self.dismiss(animated: true, completion: nil)
      }
    
    func displayErrorAlert(errorMessage:String) {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            // Present the alert view controller
            self.present(alertController, animated: true, completion: nil)
        }
    
    //MARK:- UNUSerNotificationDelegates
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound, .badge])
        }
    
}

