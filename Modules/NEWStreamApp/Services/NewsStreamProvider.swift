//
//  NewsStreamProvider.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import RxSwift
import RxCocoa
import Networking

public final class NewsStreamProvider {
    let newsApiClient = APIClient(baseURL: BaseRoutes.newsApiURL)
    
    public func loadNewsStream() -> Single<[ArticleInfo]> {
        return Single<[ArticleInfo]>.create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            
            let response: Observable<ArticlesResponse> = self.newsApiClient.send(apiRequest: TechCrunchFeedRequest())
            return response.subscribe(onNext: { response in
                    single(.success(response.articles))
                }, onError: { error in
                    single(.failure(error))
                })
        }
    }
}
