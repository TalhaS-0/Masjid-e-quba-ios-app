//
//  BaseVC.swift
//  ShifaELock
//
//  Created by Ali Waseem on 8/29/21.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
    }
    
    // Custom status bar
    //       var statusBarStyle: UIStatusBarStyle = .default {
    //           didSet {
    //               setNeedsStatusBarAppearanceUpdate()
    //           }
    //       }
    //
    //       override var preferredStatusBarStyle: UIStatusBarStyle {
    //           return statusBarStyle
    //       }
    
    // Custom Navigation and satus bar
    func titleWithNavigation(titleName: String) {
        //        self.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8157, green: 0.2078, blue: 0.2078, alpha: 1) /* #d03535 */
        navigationItem.title = titleName
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // Convert Time into time string
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func downloadImage(filePath: String, imgView: UIImageView)  {
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(with: URL(string: "\(filePath)"), placeholder: #imageLiteral(resourceName: "ic_person"), options: [.transition(.fade(1.0))], progressBlock: { receivedSize, totalSize in }, completionHandler: { result in
            switch result {

                case .success(let value):
                   // self.indicator.stopAnimating()
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    //self.indicator.stopAnimating()
                    print("Error: \(error)")
                }
            })
        }
    
    // Trim the String for Stores
    func stripFileExtension ( _ filename: String ) -> String {
        var components = filename.components(separatedBy: " ")
        guard components.count > 1 else { return filename }
        components.removeLast()
        return components.joined(separator: " ")
    }
    
    
    
    func showActionSheet(title: String!, message: String!, whatsAppCallback : @escaping () -> Void, emailCallback : @escaping () -> Void) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "About", style: .default , handler:{ (UIAlertAction)in
                print("User click whatsapp button")
                whatsAppCallback()
            }))
            
            alert.addAction(UIAlertAction(title: "Info", style: .default , handler:{ (UIAlertAction)in
                print("User click email button")
                emailCallback()
            }))

//            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
//                print("User click Delete button")
//            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
            //uncomment for iPad Support
            alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    // Simple Alert
    func showAlert(title: String!, message: String!) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Alert with yes or no
    func showAlertWithTwoButton(title : String!, message : String!, cancelBtnTitle: String!, okBtnTitle: String!,successCallback : @escaping () -> Void) -> Void {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: okBtnTitle, style: UIAlertAction.Style.destructive, handler: { (action) in
            successCallback()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Alert with ok
    func showAlertWithOneButton(title: String!, message: String!, buttonTilte: String!, successCallback: @escaping()-> Void) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTilte, style: UIAlertAction.Style.default, handler: { (action) in
            successCallback()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ActivityIndicatorShow() {
       SKActivityIndicator.show(LOADING, userInteractionStatus: false)
       SKActivityIndicator.statusTextColor(UIColor(red: 230/255, green: 90/255, blue: 37/255, alpha: 1.0) /* #e65a25 */)
       SKActivityIndicator.spinnerColor(UIColor(red: 63/255, green: 139/255, blue: 239/255, alpha: 1.0) /* #3f8bef */)
       SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
   }
    
    func ActivityIndicatorDismiss() {
        SKActivityIndicator.dismiss()
    }
    
    // Shake TextFiled
    func shakeTextField(textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    // White space validation.
    func checkTextFieldIsNotEmpty(text:String) -> Bool {
        return (text.trimmingCharacters(in: .whitespaces).isEmpty) ? false : true
    }
    
    func removeNullFromDict (dict : NSMutableDictionary) -> NSMutableDictionary {
        let dic = dict;
        for (key, value) in dict {
            let val : NSObject = value as! NSObject;
            if(val.isEqual(NSNull())) {
                dic.setValue("", forKey: (key as? String)!)
            } else {
                dic.setValue(value, forKey: key as! String)
            }
        }
        return dic;
    }
    
    // To save token in Defaults
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: USER_TOKEN)
    }
    
    func saveFilePath(_ filePath: String) {
        UserDefaults.standard.set(filePath, forKey: FILE_PATH)
    }
    
    
    // To get token from Defaults
    func getToken() -> String {
        return UserDefaults.standard.value(forKey: USER_TOKEN) as! String
    }
    
    func getFilePath() -> String {
        return UserDefaults.standard.value(forKey: FILE_PATH) as? String ?? ""
    }
    
    func clearDefaults() {
        UserDefaults.standard.removeObject(forKey: USER_TOKEN)
//        UserDefaults.standard.removeObject(forKey: USER_TOKEN)
//        SharedManager.shared.setUserData(userData: UserDataModel())
//        debugPrint(SharedManager.shared.getUserData())
    }
    
    // To save email and password in Defaults
    func saveCredentials(_ userName: String, _ password: String) {
        UserDefaults.standard.set(userName, forKey: USER_NAME)
        UserDefaults.standard.set(password, forKey: PASSWORD)
    }
    
    func convertTimeStampToDateTime(timeStamp: String) -> String {
        
        let timeInterval = Double(timeStamp)! / 1000
        //Convert to Date
        let date = NSDate(timeIntervalSince1970: timeInterval)

        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy h:mm a"
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let dateString = dateFormatter.string(from: date as Date)
        print("formatted date is =  \(dateString)")
        return dateString
    }
    
    func getCurrentDate_Month_Year() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func getCurrentDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func getCurrentMonth() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func getCurrentYear() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func getCurrentHijriDate() -> String {
        let hijriCalendar = Calendar(identifier: .islamicTabular)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.calendar = hijriCalendar
        formatter.dateFormat = "d, MMMM"
        print(formatter.string(from: Date()))
        let date = formatter.string(from: Date())
        return date
    }
    
    
    // To get email and password from Defaults
//    func getCredentials() -> Credentials {
//        var cred = Credentials()
//        cred.username = UserDefaults.standard.value(forKey: USER_NAME) as! String
//        cred.password = UserDefaults.standard.value(forKey: PASSWORD) as! String
//        return cred
//    }
    
    // To get version of the App
    func getAppVersion() -> String {
        return "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "")"
    }
    
    func InitMainViewController<T>(_ viewControllerType: T.Type) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: T.self) // Let's say view controller's storyboard identifier is same as class name
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: identifier) as! T
        UIApplication.shared.windows.first?.rootViewController = vc as? UIViewController
    }
    
    // Storyboard specific
//    func NavigateToNextVC<T:UIViewController>(viewController:T, storyboardName:String) {
//        guard let nextViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as? T else { return }
//        viewController.navigationController?.pushViewController(nextViewController, animated: true)
//    }
    
    func NavigateToNextView<T>(_ viewControllerType: T.Type) {
        let identifier = String(describing: T.self) // Let's say view controller's storyboard identifier is same as class name
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? T else { return }
        self.navigationController?.pushViewController((vc as? UIViewController)!, animated: true)
    }
    
    // To Logout user
    func logOut() {
//        showAlertWithTwoButton(title: "Alert", message: "") {
//            UserDefaults.standard.removeObject(forKey: USER_TOKEN)
//            UserDefaults.standard.removeObject(forKey: USER_DATA)
//            let userObject = UserData()
//            SharedManager.setUser(userData: userObject)
//            let appDel = UIApplication.shared.delegate as! AppDelegate
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
//            appDel.drawerController.mainViewController = vc
//            appDel.drawerController.setDrawerState(.closed, animated: true)
//        }
    }
}

