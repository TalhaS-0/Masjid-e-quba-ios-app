//
//  ApiManager.swift
//  ShifaELock
//
//  Created by Ali Waseem on 8/29/21.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class ApiManager: NSObject {
    static let shared = ApiManager()
    
    //MARK: Custom Header dictionary to HTTPHeaders
    class func DictHeaders(dict: [String: String]) -> HTTPHeaders {
        let headers = HTTPHeaders.init(dict)
        return headers
        }
    
    //MARK: Custom Header for Authorization and content type to HTTPHeaders
    class func AuthHeader(_ username: String, _ password: String) -> HTTPHeaders {
        return HTTPHeaders.init(arrayLiteral: HTTPHeader.authorization(username: username, password: password))
    }
    
    //MARK: Custom Header token to HTTPHeaders
    class func TokenHeader(_ token: String) -> HTTPHeaders {
        return HTTPHeaders.init(arrayLiteral: HTTPHeader.authorization(bearerToken: token))
    }
    
    //MARK: - Download File
     func DownloadFile (successCallback : @escaping (String) -> Void, errorCallBack : @escaping (String) -> Void) -> Void {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        ActivityIndicatorShow()
        AF.download(
            "https://www.dropbox.com/s/ls0692d7qxq3r8q/Calendar2022.xls?dl=0",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                SKActivityIndicator.dismiss()
                if DefaultDownloadResponse.fileURL != nil {
                    let filePath = DefaultDownloadResponse.fileURL
                    successCallback(filePath?.path ?? "")
                } else {
                    errorCallBack(MSG)
                }
                
            })
    }
    
    
    
    //MARK: Make Post request
    func PostRequest<T: Codable>(model: T.Type, urlString: String!, isAlertShow: Bool, parameters: Parameters, header : HTTPHeaders, successCallback : @escaping (Codable) -> Void, errorCallBack : @escaping (String) -> Void) -> Void {
        
        if !Reachability.isConnectedToNetwork() {
            print(NO_INTERNET)
            errorCallBack(NO_INTERNET)
            return
        } else {
            print("INTERNET")
        }
        if isAlertShow {
            ActivityIndicatorShow()
        }
        debugPrint(urlString!)
        debugPrint(header)
        debugPrint(parameters)
        AF.request(urlString, method: .post, parameters: parameters, headers: header).responseJSON {response in
           // print(response)
            
            SKActivityIndicator.dismiss()
            switch response.result {
            case .success(let value):
                debugPrint(value)
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        do {
                            if let data = response.data {
                            // asking the custom decoding block to do the work
                            try successCallback (JSONDecoder().decode(model, from: data))
                            }
                        } catch {
                            debugPrint(error)
                            errorCallBack(MSG)
                    }
                        break
                    default:
                        debugPrint("Default case in success")
                        let JSON = value as? [String : Any]
                        let errorMsg = JSON!["message"]
                            if errorMsg != nil {
                                errorCallBack(errorMsg as! String)
                            } else {
                                errorCallBack(MSG)
                            }
                        break
                    }
                }
            
            case .failure(let error):
                debugPrint(error.errorDescription!)
                errorCallBack(MSG)
                break
            }
        }
    }
    
    //MARK: Make Get request
    func GetRequest( urlString : String!, isAlertShow:Bool, parameters: Parameters ,header : HTTPHeaders, successCallback : @escaping (Data) -> Void, errorCallBack : @escaping (String) -> Void) -> Void {
        
        if !Reachability.isConnectedToNetwork() {
            print(NO_INTERNET)
            errorCallBack(NO_INTERNET)
            return
        } else {
            print("INTERNET")
        }
        if isAlertShow {
            ActivityIndicatorShow()
        }
        debugPrint(urlString!)
        debugPrint(header)
        debugPrint(parameters)
        AF.request(urlString, method: .get, parameters: nil, headers: nil).responseJSON { response in
          //  print(response)
            
            SKActivityIndicator.dismiss()
            switch response.result {
            case .success(let value):
                debugPrint(value)
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                            if let data = response.data {
                            // asking the custom decoding block to do the work
                            successCallback (data)
                            }
                        break
                    default:
                        errorCallBack(MSG)
                        break
                    }
                }
                
            
            case .failure(let error):
                debugPrint(error)
                errorCallBack(MSG)
                break
        
            }
        }
    }
    
    //MARK: Make Login request because OAuth 2.0 doesnot support JSON form data
    func LoginRequest<T: Codable>(model: T.Type, urlString: String!, isAlertShow: Bool, parameters: Parameters, header : HTTPHeaders, successCallback : @escaping (Codable) -> Void, errorCallBack : @escaping (String) -> Void) -> Void {
        
        if !Reachability.isConnectedToNetwork() {
            print(NO_INTERNET)
            errorCallBack(NO_INTERNET)
            return
        } else {
            print("INTERNET")
        }
        if isAlertShow {
            ActivityIndicatorShow()
        }
        debugPrint(urlString!)
        debugPrint(header)
        debugPrint(parameters)
        AF.request(urlString, method: .post, parameters: parameters, headers: header).responseJSON {response in
            print(response)
            
            SKActivityIndicator.dismiss()
            switch response.result {
            case .success(let value):
                debugPrint(value)
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        do {
                            if let data = response.data {
                            // asking the custom decoding block to do the work
                            try successCallback (JSONDecoder().decode(model, from: data))
                            }
                        } catch {
                            errorCallBack(MSG)
                    }
                        break
                    default:
                        errorCallBack(MSG)
                        break
                    }
                }
                
            case .failure(let error):
                debugPrint(error.errorDescription!)
                errorCallBack(MSG)
                break
        
            }
        }
    }
}
