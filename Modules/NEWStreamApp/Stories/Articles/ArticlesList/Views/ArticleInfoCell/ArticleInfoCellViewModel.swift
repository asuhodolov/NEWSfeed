//
//  ArticleInfoCellViewModel.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import UIKit
import Services
import RxSwift
import RxCocoa

protocol ArticleInfoCellViewModelOutput {
    var title: BehaviorRelay<String?> { get }
    var details: BehaviorRelay<String?> { get }
    var image: BehaviorRelay<UIImage?> { get }
}

final class ArticleInfoCellViewModel: Identifiable, ArticleInfoCellViewModelOutput {
    private let disposeBag = DisposeBag()

    let id: UUID
    let title = BehaviorRelay<String?>(value: nil)
    let details = BehaviorRelay<String?>(value: nil)
    let image = BehaviorRelay<UIImage?>(value: .init(named: "image_placeholder"))
    
    init(articleInfo: ArticleInfo) {
        id = articleInfo.id
        title.accept(articleInfo.title)
        details.accept(articleInfo.description)
    }
    
    func accept(image: UIImage) {
        self.image.accept(image)
    }
}
