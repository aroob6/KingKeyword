//
//  NaverAdApiViewModel.swift
//  TopKeyword
//
//  Created by 이보라 on 2022/11/14.
//

import SwiftUI
import Combine
import CryptoKit

struct KeywordList: Codable {
    let keywordList: [KeywordListElement]
}

// MARK: - KeywordListElement
struct KeywordListElement: Codable {
    let relKeyword: String
//    let monthlyPCQcCnt, monthlyMobileQcCnt: Int
//    let monthlyAvePCClkCnt, monthlyAveMobileClkCnt, monthlyAvePCCtr, monthlyAveMobileCtr: Double
//    let plAvgDepth: Int
//    let compIdx: String

//    enum CodingKeys: String, CodingKey {
//        case relKeyword
//        case monthlyPCQcCnt = "monthlyPcQcCnt"
//        case monthlyMobileQcCnt
//        case monthlyAvePCClkCnt = "monthlyAvePcClkCnt"
//        case monthlyAveMobileClkCnt
//        case monthlyAvePCCtr = "monthlyAvePcCtr"
//        case monthlyAveMobileCtr, plAvgDepth, compIdx
//    }
}


func hmacSHA256 (timestamp: Double, method: String, apiUrl: String, secretKey: String) -> String {
    let timestampString = "\(Int(timestamp))"
    let secretKeyData = Data(secretKey.utf8)
    let symmetricKey = SymmetricKey(data: secretKeyData)
    let generateSignatureStringData = "\(timestampString).\(method).\(apiUrl)"
    let generateSignatureData = Data(generateSignatureStringData.utf8)
    
    var hmac = HMAC<SHA256>.init(key: symmetricKey)
    hmac.update(data: generateSignatureData)
    
    return Data(hmac.finalize()).base64EncodedString()
}

class NaverAdApiViewModel: ObservableObject {
    @Published var keywordList = KeywordList(keywordList: [KeywordListElement(relKeyword: "0")])
    var cancellables = Set<AnyCancellable>()
    
    func getRelKwdStat(query: String) {
        let url = "https://api.naver.com/keywordstool"
        guard var urlComponents = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "hintKeywords", value: query),
            URLQueryItem(name: "showDetail", value: "1")
        ]
        
        guard let requestURL = urlComponents.url else { return }
        var request = URLRequest(url: requestURL)
        
        let METHOD = "GET"
        let APIURI = "/keywordstool"
        let CURRENTTIME = NSDate().timeIntervalSince1970 * 1000
        let SECRET_KEY = "AQAAAABqrnCYwJrp7ROCMWtGi3ewiYrZy3631Ba3r2YRPVhAPQ=="
        let API_KEY = "01000000006aae7098c09ae9ed1382316b468b77b08f259febf908b03985d5dd586380c81e"
        let CustomerKey = "2713303"
        let SIGNATURE = hmacSHA256(timestamp: CURRENTTIME, method: METHOD, apiUrl: APIURI, secretKey: SECRET_KEY)

        request.addValue("\(Int(CURRENTTIME))", forHTTPHeaderField: "X-Timestamp")
        request.addValue(API_KEY, forHTTPHeaderField: "X-API-KEY")
        request.addValue(SIGNATURE, forHTTPHeaderField: "X-Signature")
        request.addValue(CustomerKey, forHTTPHeaderField: "X-Customer")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: KeywordList.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] res in
                self?.keywordList = res
            }
            .store(in: &cancellables)
    }
    
}
