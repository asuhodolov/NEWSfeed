//
//  APIClient.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 22.12.22.
//

import Foundation
import RxSwift
import RxCocoa

public class APIClient {
    private let baseURL: URL 

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return URLSession.shared.rx
            .data(request: apiRequest.request(with: baseURL))
            .map {
                try JSONDecoder().decode(T.self, from: $0)
            }.observe(on: MainScheduler.asyncInstance)
    }
}
