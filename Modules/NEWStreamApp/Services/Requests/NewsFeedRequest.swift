//
//  NewsFeedRequest.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import RxSwift
import Networking

struct TechCrunchFeedRequest: APIRequest {
    var method: RequestType = .GET
    var path = "top-headlines"
    var parameters = ["sources": "techcrunch",
                      "apiKey": BaseRoutes.newsApiKey]
}
