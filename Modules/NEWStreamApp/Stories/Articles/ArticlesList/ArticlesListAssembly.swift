//
//  ArticlesListAssembly.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import Services
import UIKit

public final class ArticlesListAssembly {
    public struct Dependencies {
        public let imageLoader: ImageFetcher
        public let articlesProvider: NewsStreamProvider
        
        public init(imageLoader: ImageFetcher,
                    articlesProvider: NewsStreamProvider) {
            self.imageLoader = imageLoader
            self.articlesProvider = articlesProvider
        }
    }
    
    public class func assemble(dependencies: Dependencies,
                               router: ArticlesListRouter) -> UIViewController {
        let viewModel = ArticlesListViewModel(imageLoader: dependencies.imageLoader,
                                              newsProvider: dependencies.articlesProvider,
                                              articlesListRouter: router)
        return ArticlesListViewController(viewModel: viewModel)
    }
}
