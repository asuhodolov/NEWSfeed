//
//  ArticleDetailsViewModel.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 31.12.22.
//

import Foundation
import RxSwift
import RxCocoa
import Services
import UIKit

protocol ArticleDetailsViewModelOutput {
    var articleImage: BehaviorRelay<UIImage?> { get }
    var articleTitle: BehaviorRelay<String> { get }
    var articleContent: BehaviorRelay<String?> { get }
}

protocol ArticleDetailsViewModelInput {}


final class ArticleDetailsViewModel: ArticleDetailsViewModelOutput, ArticleDetailsViewModelInput {
    let imageLoader: ImageFetcher
    let articleInfo: ArticleInfo
    let disposeBag = DisposeBag()
    
//MARK: ArticleDetailsViewModelOutput
    
    let articleImage = BehaviorRelay<UIImage?>(value: .init(named: "image_placeholder"))
    let articleTitle = BehaviorRelay<String>(value: "")
    let articleContent = BehaviorRelay<String?>(value: nil)
    
//MARK: Init

    init(articleInfo: ArticleInfo,
         imageLoader: ImageFetcher) {
        self.articleInfo = articleInfo
        self.imageLoader = imageLoader        
        prepareViewModel()
    }

    private func prepareViewModel () {
        loadImage()
        articleTitle.accept(articleInfo.title)
        articleContent.accept(articleInfo.content)
    }
    
    private func loadImage() {
        guard let imageURLString = articleInfo.imageUrlString,
            let imageURL = URL(string: imageURLString)
        else { return }
        
        imageLoader.loadImage(url: imageURL)
            .subscribe { event in
                switch event {
                case .success(let image):
                    if let image = image {
                        self.articleImage.accept(image)
                    }
                case .failure(let error):
                    print("Image loading error: \(error)")
                }
            }.disposed(by: self.disposeBag)
    }
}
