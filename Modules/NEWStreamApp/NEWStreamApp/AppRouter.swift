//
//  AppRouter.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 22.12.22.
//

import Foundation
import UIKit
import Services
import Articles

public final class ApplicationRouter: NSObject {
    private let window: UIWindow
    private let services = Services()
    private var articlesNavigationController: UINavigationController?

    
    public required init(window: UIWindow) {
        self.window = window
    }
    
    public func presentRootController() {
        let navigationController = makeScootersMapStory()
        articlesNavigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    //MARK: JobsList Scene
    
    private func makeScootersMapStory() -> UINavigationController {
        let dependencies = ArticlesListAssembly.Dependencies(imageLoader: services.imageFetcher,
                                                             articlesProvider: services.articlesProvider)
        let articlesController = ArticlesListAssembly.assemble(dependencies: dependencies,
                                                               router: self)
        let navigationController = UINavigationController(rootViewController: articlesController)
        return navigationController
    }
}

//MARK: - ArticlesListRouter

extension ApplicationRouter: ArticlesListRouter {
    public func showDetails(for articleInfo: ArticleInfo) {
        let dependencies = ArticleDetailsAssembly.Dependencies(imageLoader: services.imageFetcher)
        let detailsController = ArticleDetailsAssembly.assemble(articleInfo: articleInfo,
                                                                dependencies: dependencies)
        articlesNavigationController?.pushViewController(detailsController,
                                                         animated: true)
    }
}
