//
//  NaverAdApiViewModel.swift
//  TopKeyword
//
//  Created by 이보라 on 2022/11/14.
//

import SwiftUI
import Combine

struct RelKwdStat: Codable {
    let total: Int
}

class NaverAdApiViewModel: ObservableObject {
    @Published var relKwdStat = RelKwdStat(total: 0)
    var cancellables = Set<AnyCancellable>()
    
    func getBlog(query: String) {
        let url = "https://api.naver.com"
        guard var urlComponents = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        
        guard let requestURL = urlComponents.url else { return }
        var request = URLRequest(url: requestURL)
        
//        API_KEY = '*****'
//        SECRET_KEY = '*****'
//        CUSTOMER_ID = '****'

        request.addValue("01000000006aae7098c09ae9ed1382316b468b77b08f259febf908b03985d5dd586380c81e", forHTTPHeaderField: "API_KEY")
        request.addValue("AQAAAABqrnCYwJrp7ROCMWtGi3ewiYrZy3631Ba3r2YRPVhAPQ==", forHTTPHeaderField: "SECRET_KEY")
        request.addValue("2713303", forHTTPHeaderField: "CUSTOMER_ID")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: RelKwdStat.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] res in
                self?.relKwdStat = res
            }
            .store(in: &cancellables)
    }
    
}
