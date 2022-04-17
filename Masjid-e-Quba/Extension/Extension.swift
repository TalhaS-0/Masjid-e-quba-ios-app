//
//  Extension.swift
//  iyziliOSApp
//
//  Created by Ali Waseem on 11/24/21.
//

import UIKit
import Foundation
import SKActivityIndicatorView

extension UIView {
    // For shadow
    
    func shadowToCell(cornerRadius:CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset =  CGSize.zero
        layer.shadowRadius = 4
    }
    
    func roundTop(radius:CGFloat){
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        }

        func roundBottom(radius:CGFloat){
            self.clipsToBounds = true
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOpacity = 0.7
            self.layer.shadowOffset =  CGSize.zero
            self.layer.shadowRadius = 4
            self.layer.cornerRadius = radius
            if #available(iOS 11.0, *) {
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


extension Encodable {
    
//    guard let jsonObj = finalObj.dictionary else {return}
//    print(jsonObj)
//    let dic = NSMutableDictionary(dictionary: jsonObj)
//    print(dic)

  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }

}


extension UIImageView {

    func makeRoundedImage() {
        //self.layer.borderWidth = 1
        self.layer.masksToBounds = false
       // self.layer.borderColor = UIColor.black.cgColor
        //let a = (self.frame.width / 2) + (self.frame.height / 2)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}


private var maxLengths = [UITextField: Int]()
private var minLengths = [UITextField: Int]()

extension UITextField {
    
    //MARK:- Maximum length
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return 100
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(fixMax), for: .editingChanged)
        }
    }
    @objc func fixMax(textField: UITextField) {
        let text = textField.text
        textField.text = text?.safelyLimitedTo(length: maxLength)
    }
    
    //MARk:- Minimum length
    @IBInspectable var minLegth: Int {
        get {
            guard let l = minLengths[self] else {
                return 0
            }
            return l
        }
        set {
            minLengths[self] = newValue
            addTarget(self, action: #selector(fixMin), for: .editingChanged)
        }
    }
    @objc func fixMin(textField: UITextField) {
        let text = textField.text
        textField.text = text?.safelyLimitedFrom(length: minLegth)
    }
    
    @IBInspectable public var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
             }
        }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
}

extension String
{
    var length: Int { return self.count }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func safelyLimitedFrom(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func getCurrentDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
            
    func replacingRange(indexFromStart: Int, indexFromEnd: Int, replacing: String = "") -> Self {
        return self.replacingOccurrences(of: self.dropFirst(indexFromStart).dropLast(indexFromEnd), with: replacing)
    }
        
    func replacingRange2(indexFromStart: Int, indexFromEnd: Int, replacing: String = "") -> Self {
        return String(self.prefix(indexFromStart)) + replacing + String(self.suffix(indexFromEnd))
    }
    
    func replace(string:String, replacement:String) -> String {
            return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
        }

    func removeWhitespace() -> String {
            return self.replace(string: " ", replacement: "")
    }
}

extension ApiManager {
     func ActivityIndicatorShow() {
        SKActivityIndicator.show(LOADING, userInteractionStatus: false)
        SKActivityIndicator.statusTextColor(#colorLiteral(red: 0.898, green: 0.2588, blue: 0.0235, alpha: 1) /* #e54206 */)
        SKActivityIndicator.spinnerColor(#colorLiteral(red: 0.6588, green: 0.4039, blue: 0.8196, alpha: 1) /* #a867d1 */)
        SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
    }
}


@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            navigationBar.barTintColor = newValue
        }
        get {
            guard  let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }

    @IBInspectable var tintColor: UIColor? {
        set {
            navigationBar.tintColor = newValue
        }
        get {
            guard  let color = navigationBar.tintColor else { return nil }
            return color
        }
    }

    @IBInspectable var titleColor: UIColor? {
        set {
            guard let color = newValue else { return }
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        }
        get {
            return navigationBar.titleTextAttributes?[NSAttributedString.Key(rawValue: "NSForegroundColorAttributeName") ] as? UIColor
        }
    }
}


extension UIButton {
    func buttonShadowWithBorder(radius : CGFloat) {
        self.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.8980392157, blue: 0.9607843137, alpha: 1) /* #e9dbf1 */.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.6588, green: 0.4039, blue: 0.8196, alpha: 1) /* #a867d1 */.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
    }
    
    func buttonShadowAndFont(radius : CGFloat, font : UIFont?) {
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) /* #ffffff */.cgColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.titleLabel?.font = font
    }
    
    func buttonRadiusAndFont(radius : CGFloat, font : UIFont?) {
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) /* #ffffff */.cgColor
        self.layer.cornerRadius = radius
//        self.clipsToBounds = true
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 2.0
        self.titleLabel?.font = font
    }
    
    func buttonRadius(radius : CGFloat) {
        self.layer.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0.2078431373, blue: 0.2078431373, alpha: 1) /* #ffffff */.cgColor
        self.layer.cornerRadius = radius
    }
    
}


extension UISwitch {

func increaseThumb(){
    if let thumb = self.subviews[0].subviews[1].subviews[2] as? UIImageView {
        thumb.transform = CGAffineTransform(scaleX:0.9, y: 0.9)
    }
  }
}

extension UIFont {
    static func LatoBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Lato-Bold", size: size)
    }
    
    static func LatoBlack(size: CGFloat) -> UIFont? {
        return UIFont(name: "Lato-Black", size: size)
    }
    
    static func LatoRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Lato-Regular", size: size)
    }
}

extension UIColor {
    static let darkpurple = #colorLiteral(red: 0.6588, green: 0.4039, blue: 0.8196, alpha: 1) /* #a867d1 */
    static let backgroundPurple = #colorLiteral(red: 0.9137, green: 0.8588, blue: 0.9451, alpha: 1) /* #e9dbf1 */
    static let redThemeColor = #colorLiteral(red: 0.8156862745, green: 0.2078431373, blue: 0.2078431373, alpha: 1) /* #e9dbf1 */
}


extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }

    private class func _share(_ data: [Any],
                              applicationActivities: [UIActivity]?,
                              setupViewControllerCompletion: ((UIActivityViewController) -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        setupViewControllerCompletion?(activityViewController)
        UIApplication.topViewController?.present(activityViewController, animated: true, completion: nil)
    }

    class func share(_ data: Any...,
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil) {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
    class func share(_ data: [Any],
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil) {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
}


extension String {
    
    func stripOutHtml() -> String? {
            do {
                guard let data = self.data(using: .unicode) else {
                    return nil
                }
                let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                return attributed.string
            } catch {
                return nil
            }
        }

  //MARK:- Convert UTC To Local Date by passing date formats value
  func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = incomingFormat
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    let dt = dateFormatter.date(from: self)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = outGoingFormat

    return dateFormatter.string(from: dt ?? Date())
  }

  //MARK:- Convert Local To UTC Date by passing date formats value
  func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = incomingFormat
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current

    let dt = dateFormatter.date(from: self)
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = outGoingFormat

    return dateFormatter.string(from: dt ?? Date())
  }
}
