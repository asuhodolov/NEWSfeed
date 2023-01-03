//
//  ArticleDetailsAssembly.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 31.12.22.
//

import Foundation
import Services
import UIKit

public final class ArticleDetailsAssembly {
    public struct Dependencies {
        let imageLoader: ImageFetcher
        
        public init(imageLoader: ImageFetcher) {
            self.imageLoader = imageLoader
        }
    }
    
    public class func assemble(articleInfo: ArticleInfo,
                               dependencies: Dependencies) -> UIViewController {
        let viewModel = ArticleDetailsViewModel(articleInfo: articleInfo,
                                                imageLoader: dependencies.imageLoader)
        return ArticleDetailsViewController(viewModel: viewModel)
    }
}
