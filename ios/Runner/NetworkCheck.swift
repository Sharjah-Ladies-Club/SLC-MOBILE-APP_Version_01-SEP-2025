//
//  NetworkCheck.swift
//  APICall
//
//  Created by Antony Leo Ruban Yesudass on 03/05/20.
//  Copyright © 2020 Antony. All rights reserved.
//

import Foundation
import SystemConfiguration

//Enumeration definition for WiFi and WWAN
enum ReachabilityType: CustomStringConvertible {
    case WWAN
    case WiFi
    
    var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}
// Enumeration Definitino for Reachability Status
enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}

class NetworkCheck: NSObject {
    // Singleton Class - Shared Object
    static let sharedInstance = NetworkCheck()
    
    func isInternetConnectionAvailable() -> Bool {
        let status = NetworkCheck.sharedInstance.connectionStatus()
        switch status {
        case .Unknown, .Offline:
            // Not connected
            return false
        case .Online(.WWAN):
            // Connected via WWAN
            return true
        case .Online(.WiFi):
            // Connected via WiFi
            return true
        }
    }
    // Connection Status Method
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .Unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .Unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    // Monitor the Reachability Changes
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            _ = ReachabilityStatus(reachabilityFlags: flags)
            
          //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.KReachabilityStatusChangedNotificationMessage), object: nil, userInfo: ["Status": status.description])
        }, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
}
// Extension for Reachability Status
extension ReachabilityStatus {
    public init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
}
