//
//  ArticlesListViewController.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional
import Shared

internal final class ArticlesListViewController: UITableViewController {
    private let viewModel: ArticlesListViewModelOutput & ArticlesListViewModelInput
    private let disposeBag = DisposeBag()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .init(x: 0,
                                           y: 0,
                                           width: view.frame.size.width,
                                           height: 44.0))
        return bar
    }()
    
    private let articlesLoadingRefreshControl = RefreshControl(refreshViewController: GlobeSpinnerViewController())
    
    
    //MARK: - Initialization
    
    init(viewModel: ArticlesListViewModelOutput & ArticlesListViewModelInput) {
        self.viewModel = viewModel
        super.init(style: .plain)
        
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ArticlesListViewController must be initialized using init(viewModel:)")
    }
    
    
    //MARK: - UI
    
    override func viewDidLoad() {
        prepareUI()
        viewModel.onViewDidLoad.onNext(())
    }
    
    private func prepareUI() {
        navigationItem.title = NSLocalizedString("ArticlesList_navigationItemTitle_recentNews",
                                                 value: "Recent News",
                                                 comment: "Title for News feed page")
        navigationItem.hidesSearchBarWhenScrolling = true
        prepareTableView()
        prepareRefreshControl()
    }
    
    private func prepareTableView() {
        tableView.tableHeaderView = searchBar
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(ArticleInfoCell.self,
                           forCellReuseIdentifier: ArticleInfoCell.reusableIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    private func prepareRefreshControl() {
        view.addSubview(articlesLoadingRefreshControl)
    }
    
    //MARK: - View Model binding
    
    private func bindViewModel() {
        tableView.rx.willDisplayCell
            .map { event -> ArticleInfoCellViewModel? in
                return try? self.tableView.rx.model(at: event.indexPath)
            }.filterNil()
            .subscribe(viewModel.willDisplayImageItem)
            .disposed(by: disposeBag)
        
        articlesLoadingRefreshControl.onRefresh
            .subscribe(viewModel.onRefreshTriggered)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ArticleInfoCellViewModel.self)
            .subscribe(viewModel.onUserSelectedItem)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe(viewModel.searchQuery)
            .disposed(by: disposeBag)
        
        viewModel.articleCellItems
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: ArticleInfoCell.reusableIdentifier,
                                      cellType: ArticleInfoCell.self))
            { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: disposeBag)
        
        viewModel.loadingData
            .asDriver()
            .drive(articlesLoadingRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

