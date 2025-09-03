//
//  Webservice.swift
//
//  Created by Paradigm Pioneers, Inc on 18/05/18.
//  Copyright © 2018 Paradigm Pioneers, Inc. All rights reserved.
//

import UIKit

typealias WebServiceCallCompletionHandler = (_ response: [String : Any]?, _ isError :Bool , _ errorMessage: String?) ->Void
typealias DownloadCompletionHandler = (_ result: Data?, _ isError :Bool , _ errorMessage: String?) ->Void
typealias UploadCompletionHandler = (_ response: [String : Any]?, _ isError : Bool,_ errorMessage: String?) ->Void

class Webservice: Operation,URLSessionDelegate,URLSessionTaskDelegate, URLSessionDownloadDelegate, URLSessionDataDelegate {
    
    // Properties / Variables
    var session : URLSession?
    static var webService: Webservice?
    static var avertQueue: OperationQueue = OperationQueue()
    
    var request : URLRequest?
    var webData : Data?
    var webServiceCallCompletionHandler : WebServiceCallCompletionHandler?
    var downloadCompletionHandler : DownloadCompletionHandler?
    var uploadCompletionHandler : UploadCompletionHandler?
    
    var isBackground = false
    var isDataTask = false
    var isDownloadTask = false
    var isUploadTask = false
    
    // Initialization
    override init() {
        super.init()
        Webservice.avertQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
    }
    
    class func sharedHelper() -> Webservice {
        webService = Webservice()
        return webService!
    }
    
    class func sharedHelperWithBackgroundMode() -> Webservice {
        webService = Webservice()
        webService!.enableBackgroundMode()
        return webService!
    }
    // Operation Queue Initialization
    class func operationQueue() -> OperationQueue
    {
        return avertQueue
    }
    // Background Enable
    func enableBackgroundMode() -> Void {
        isBackground = true;
    }
    
    // Convert Data to Dictionary
    func convertDataToDictionary(data: Data) -> [String:Any]? {
        do{
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
        } catch let error{
            print(error)
        }
        return nil
    }
    
    // Session Background Delegate Method
    func sessionFunction() -> URLSession {
        session = nil
        if isBackground {
            let sessionIdentifier = String(format: "com.newboevolve.app.BackgroundSession%d", arc4random())
            let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
            session = Foundation.URLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: nil)
        } else{
            let configuration = URLSessionConfiguration.default
            session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        }
        return session!
    }
    
    //  Web Service Call
    func callWebServiceWith(methodURL: String, args: [String : Any] = [:], completionHandler: @escaping WebServiceCallCompletionHandler ) -> Void {
       // if NetworkCheck.sharedInstance.isInternetConnectionAvailable() {
            
            let createRquestResponse = self.getAPIRequestWith(methodURL: methodURL, arguments: args)
            if createRquestResponse.isError
            {
                completionHandler(nil,true,createRquestResponse.errorMessage)
            } else
            {
                request = createRquestResponse.request
                webServiceCallCompletionHandler = completionHandler
                isDataTask = true
                Webservice.operationQueue().addOperation(self)
            }
       // } else {
            //completionHandler(nil, true, kNoNetworkMessage);
       // }
    }
    
    //UploadData Web Service Call
    
          
    // Task Method
    override func start() -> Void {
        // Check if Cancelled or not
        if !isCancelled {
            if isDownloadTask {
                // Download Task
                let downloadtask = sessionFunction().downloadTask(with: request! as URLRequest)
                downloadtask.resume()
            } else if isUploadTask {
                // Upload Task
                webData = nil
                webData = Data()
                let uploadDataTask = sessionFunction().dataTask(with: request! as URLRequest)
                uploadDataTask.resume()
            }else{
                if isBackground {
                    // Backgound Task
                    let downloadtask = sessionFunction().downloadTask(with: request! as URLRequest)
                    downloadtask.resume()
                }else {
                    // Web Data Task
                    webData = nil
                    webData = Data()
                    let uploadDataTask = sessionFunction().dataTask(with: request! as URLRequest)
                    uploadDataTask.resume()
                    
                }
            }
        }else{
            if isDownloadTask {
                // Cancelled Download Task
                downloadCompletionHandler! (nil, true, "Download operation canceled")
                downloadCompletionHandler = nil
            }else {
                webServiceCallCompletionHandler!(nil, true , "Web Service Call operation canceled")
                webServiceCallCompletionHandler = nil
            }
        }
    }
    
    // Url Session Delegate Method for Download Task
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Checking Response Code is 200 or not for Download Task
        if (downloadTask.response as! HTTPURLResponse).statusCode != 200 {
            // Response Code not equals to 200
        } else {
            if isDownloadTask {
                // Download Task response
                if FileManager.default.fileExists(atPath: location.path)
                {
                    do {
                        let imageData : Data? = try Data(contentsOf: location as URL)
                        if imageData != nil{
                            downloadCompletionHandler! (imageData, false, "Success")
                            downloadCompletionHandler = nil
                        }else {
                            downloadCompletionHandler! (imageData, false, "Failed")
                            downloadCompletionHandler = nil
                        }
                        do{
                            try  FileManager.default.removeItem(at: location as URL)
                        } catch {
                            
                        }
                    } catch{
                        
                    }
                }
                
            } else if self.isDataTask { // Data Task Response
                if FileManager.default.fileExists(atPath: location.path)
                {
                    do{
                        let responseData : Data? = try Data(contentsOf: location as URL)
                        let response:[String:Any]? = try JSONSerialization.jsonObject(with: responseData! as Data, options: .allowFragments) as? [String : Any]
                        if response == nil {
                            // webServiceCallCompletionHandler!(nil,true,Constants.kExceptionMessage)
                        } else {
                            webServiceCallCompletionHandler!(response!,false,"Success")
                        }
                        webServiceCallCompletionHandler = nil
                    } catch let error1{
                        print("json error: \(error1.localizedDescription)")
                        do{
                            try  FileManager.default.removeItem(at: location as URL)
                        } catch {
                            
                        }
                        webServiceCallCompletionHandler!(nil, true , error1.localizedDescription)
                        webServiceCallCompletionHandler = nil
                    }
                }
            } else if self.isUploadTask { // Upload Task Response
                if FileManager.default.fileExists(atPath: location.path)
                {
                    do{
                        let responseData : Data? = try Data(contentsOf: location as URL)
                        let response:[String:Any]? = try JSONSerialization.jsonObject(with: responseData! as Data, options: .allowFragments) as? [String : Any]
                        if response == nil {
                            // uploadCompletionHandler!(nil,true,Constants.kExceptionMessage)
                        } else {
                            uploadCompletionHandler!(response!,false,"Success")
                        }
                        uploadCompletionHandler = nil
                    } catch let error1{
                        
                        print("json error: \(error1.localizedDescription)")
                        
                        do{
                            try  FileManager.default.removeItem(at: location as URL)
                        } catch {
                            
                        }
                        webServiceCallCompletionHandler!(nil, true , error1.localizedDescription)
                        webServiceCallCompletionHandler = nil
                    }
                }
                
            }
        }
    }
    
    // Url Session Delegate Method for URL Session Task
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // Checking Error is Equals to nil
        if error == nil {
            // Checking Response Code is not Equals to 200 or not for URL Session Task
            
            if (task.response as! HTTPURLResponse).statusCode != 200 {
                if self.isDownloadTask {
                    // Error Message for Download Task
                    //  downloadCompletionHandler! (nil, true, Constants.kServerExceptionMessage)
                    downloadCompletionHandler = nil
                } else if isUploadTask {
                    // Error Message for Upload Task
                    // uploadCompletionHandler!(nil, true , Constants.kServerExceptionMessage)
                    uploadCompletionHandler = nil
                } else {
                    //  webServiceCallCompletionHandler!(nil, true , Constants.kServerExceptionMessage)
                    webServiceCallCompletionHandler = nil
                }
            } else {
                // Getting Web Service Response
                if isDataTask && !isBackground {
                    
                    
                    if webData != nil
                    {
                        let imageSize: Int = webData!.count
                        let params = [ "imageSize" : imageSize,
                            ] as [String : Any]
                        webServiceCallCompletionHandler!(params,false,"Success")
                    }else
                    {
                        webServiceCallCompletionHandler!(nil,false,"Success")
                    }
                    
//                    let response = convertDataToDictionary(data: webData!)
//                    if response == nil
//                    {
//                        if webData != nil
//                        {
//                            let imageSize: Int = webData!.count
//                            let params = [ "imageSize" : imageSize,
//                                ] as [String : Any]
//                            webServiceCallCompletionHandler!(params,false,"Success")
//                        }else
//                        {
//                            webServiceCallCompletionHandler!(nil,false,"Success")
//                        }
//                    }else
//                    {
//                        webServiceCallCompletionHandler!(response,false,"Success")
//                    }
//                    webServiceCallCompletionHandler = nil
                    
                    
                } else if isUploadTask {
                    let response = convertDataToDictionary(data: webData!)
                    if response == nil {
                        //uploadCompletionHandler!(nil,true,Constants.kExceptionMessage)
                    }else {
                        uploadCompletionHandler!(response,false,"Success")
                    }
                    uploadCompletionHandler = nil
                }
            }
        } else {
            if self.isDownloadTask {
                downloadCompletionHandler! (nil, true, error?.localizedDescription)
                downloadCompletionHandler = nil
            } else if isUploadTask {
                uploadCompletionHandler!(nil, true , error?.localizedDescription)
                uploadCompletionHandler = nil
            } else {
                webServiceCallCompletionHandler!(nil, true , error?.localizedDescription)
                webServiceCallCompletionHandler = nil
            }
        }
    }
    // Url Session Delegate Method
    func urlSession(_ session: URLSession,downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        
    }
    // Url Session Delegate Method for Url Session Data Task
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if self.isDownloadTask {
            completionHandler(Foundation.URLSession.ResponseDisposition.becomeDownload)
        } else if self.isUploadTask {
            self.webData?.count=0
            completionHandler(Foundation.URLSession.ResponseDisposition.allow)
        } else {
            self.webData?.count=0
            completionHandler(Foundation.URLSession.ResponseDisposition.allow)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        webData?.append(data as Data)
    }
    
    // Url Session Delegate Method
    
    
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session:URLSession) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.backgroundSessionCompletionHandler.keys.count > 0 {
            let completionHandler = appDelegate.backgroundSessionCompletionHandler[session.configuration.identifier!]
            appDelegate.backgroundSessionCompletionHandler.removeValue(forKey: session.configuration.identifier!)
            OperationQueue.main.addOperation(){
                // Call the completion handler to tell the system that there are no other background transfers.
                completionHandler!()
            }
        }
    }
    
    
    // Create Request Method
    func getAPIRequestWith(methodURL:String, arguments:[String : Any],data : Data? = nil, fileName : String = "", mimeType : String = "")->(isError:Bool, errorMessage:String?, request:URLRequest?){
        
               
        let urlString:String = "\(methodURL)\("?")"
               
               var request = URLRequest(url: URL(string: urlString)!)
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               request.addValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
               request.httpMethod = "Get"
               return (false, nil, request)
          
    }
   
}


