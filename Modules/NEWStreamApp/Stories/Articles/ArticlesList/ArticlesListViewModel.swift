//
//  ArticlesListViewModel.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import Services

protocol ArticlesListViewModelOutput {
    var articleCellItems: Driver<[ArticleInfoCellViewModel]> { get }
    var loadingData: BehaviorRelay<Bool> { get }
}

protocol ArticlesListViewModelInput {
    var onViewDidLoad: PublishSubject<Void> { get }
    var onRefreshTriggered: PublishSubject<Void> { get }
    var willDisplayImageItem: PublishSubject<ArticleInfoCellViewModel> { get }
    var onUserSelectedItem: PublishSubject<ArticleInfoCellViewModel> { get }
    var searchQuery: BehaviorSubject<String> { get }
}


//MARK: - ArticlesListViewModel

final class ArticlesListViewModel: ArticlesListViewModelInput, ArticlesListViewModelOutput {
    let imageLoader: ImageFetcher
    let newsProvider: NewsStreamProvider
    let router: ArticlesListRouter
    let disposeBag = DisposeBag()
    
    private let articlesRelay = BehaviorRelay<[ArticleInfo]>(value: [])
    
//MARK: ArticlesListViewModelInput
    
    let onViewDidLoad = PublishSubject<Void>()
    let onRefreshTriggered = PublishSubject<Void>()
    let willDisplayImageItem = PublishSubject<ArticleInfoCellViewModel>()
    let onUserSelectedItem = PublishSubject<ArticleInfoCellViewModel>()
    let searchQuery = BehaviorSubject<String>(value:"")
    
//MARK: ArticlesListViewModelOutput

    let loadingData = BehaviorRelay<Bool>(value: true)
    lazy var articleCellItems = {
        Observable
            .combineLatest(articlesRelay,
                           searchQuery)
            .map ({ (articlesList, searchFilter) -> [ArticleInfoCellViewModel]? in
                return articlesList.filter { articleInfo in
                    guard !searchFilter.isEmpty else { return true }
                    return articleInfo.title.lowercased().contains(searchFilter.lowercased())
                        || articleInfo.description?.lowercased().contains(searchFilter.lowercased()) ?? false
                }.map { articleInfo in
                    return ArticleInfoCellViewModel(articleInfo: articleInfo)
                }
            })
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
    }()
        
//MARK: Init
    
    init(imageLoader: ImageFetcher,
         newsProvider: NewsStreamProvider,
         articlesListRouter: ArticlesListRouter) {
        self.imageLoader = imageLoader
        self.newsProvider = newsProvider
        self.router = articlesListRouter
        
        prepareViewModel()
    }
    
    private func prepareViewModel () {
        prepareImageLoader()
        subscribeToArticleSelection()
        subscribeToRefreshAction()
    }
    
    private func subscribeToRefreshAction() {
        Observable.merge([onViewDidLoad, onRefreshTriggered])
            .flatMap { [weak self] _ -> Single<[ArticleInfo]> in
                return self?.newsProvider.loadNewsStream() ?? Single.just([])
            }.subscribe { [weak self] articles in
                self?.articlesRelay.accept(articles)
                self?.loadingData.accept(false)
            } onError: { [weak self] error in
                self?.loadingData.accept(false)
                print("Articles loading error: \(error)")
            }.disposed(by: disposeBag)
    }
    
    private func prepareImageLoader() {
        willDisplayImageItem.subscribe { [weak self] event in
            guard let elementViewModel = event.element,
                  let articlesRelay = self?.articlesRelay
            else { return }
            
            let articleInfo = articlesRelay.value.first {
                $0.id == elementViewModel.id
            }
            
            guard let URLString = articleInfo?.imageUrlString,
                  let imageURL = URL(string: URLString),
                  let self = self
            else { return }
            
            self.imageLoader.loadImage(url: imageURL)
                .subscribe { event in
                    switch event {
                    case .success(let image):
                        if let image = image {
                            elementViewModel.accept(image: image)
                        }
                    case .failure(let error):
                        print("Image loading error: \(error)")
                    }
                }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToArticleSelection() {
        onUserSelectedItem.subscribe { [weak self] event in
            guard let elementViewModel = event.element else { return }
            let articleInfo = self?.articlesRelay.value.first {
                $0.id == elementViewModel.id
            }
            guard let articleInfo = articleInfo else { return }
            self?.router.showDetails(for: articleInfo)
        }.disposed(by: disposeBag)
    }
}
