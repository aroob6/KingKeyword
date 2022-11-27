//
//  TopKeywordApp.swift
//  TopKeyword
//
//  Created by bora on 2022/11/10.
//

import SwiftUI
import GoogleMobileAds
import AdSupport
import AppTrackingTransparency

@main
struct TopKeywordApp: App {
    init() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if #available(iOS 14, *) {
//                ATTrackingManager.requestTrackingAuthorization { status in
//                    switch status {
//                    case .authorized:           // 허용됨
//                        print("Authorized")
//                        print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")
//                    case .denied:               // 거부됨
//                        print("Denied")
//                    case .notDetermined:        // 결정되지 않음
//                        print("Not Determined")
//                    case .restricted:           // 제한됨
//                        print("Restricted")
//                    @unknown default:           // 알려지지 않음
//                        print("Unknow")
//                    }
//                }
//            }
//        }
        GADMobileAds.sharedInstance().start()
    }
    var body: some Scene {
        WindowGroup {
            SearchView()
        }
    }
}
