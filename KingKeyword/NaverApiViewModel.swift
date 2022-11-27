//
//  BlogCafeCount.swift
//  TopKeyword
//
//  Created by 이보라 on 2022/11/11.
//

import SwiftUI
import Combine

struct BlogModel: Codable {
    let total: Int
}

struct CafeModel: Codable {
    let total: Int
}

class NaverApiViewModel: ObservableObject {
    @Published var blogs = BlogModel(total: 0)
    @Published var cafes = CafeModel(total: 0)
    var cancellables = Set<AnyCancellable>()
    
    func reset() {
        self.blogs = BlogModel(total: 0)
        self.cafes = CafeModel(total: 0)
    }
    
    func getBlog(query: String) {
        let url = "https://openapi.naver.com/v1/search/blog.json"
        guard var urlComponents = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        
        guard let requestURL = urlComponents.url else { return }
        var request = URLRequest(url: requestURL)
        
        request.addValue("a1fn17TrDxH4FTh4Tq2F", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("n3FiFC7H4W", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: BlogModel.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] res in
                self?.blogs = res
            }
            .store(in: &cancellables)
    }
    
    func getCafe(query: String) {
        let url = "https://openapi.naver.com/v1/search/cafearticle.json"
        guard var urlComponents = URLComponents(string: url) else {
            print("Error: cannot create URLComponents")
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        
        guard let requestURL = urlComponents.url else { return }
        var request = URLRequest(url: requestURL)
        
        request.addValue("a1fn17TrDxH4FTh4Tq2F", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("n3FiFC7H4W", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CafeModel.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] res in
                self?.cafes = res
            }
            .store(in: &cancellables)
    }
}
