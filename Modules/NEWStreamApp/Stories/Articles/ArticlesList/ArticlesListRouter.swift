//
//  ArticlesListRouter.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import Services

public protocol ArticlesListRouter {
    func showDetails(for articleInfo: ArticleInfo)
}
