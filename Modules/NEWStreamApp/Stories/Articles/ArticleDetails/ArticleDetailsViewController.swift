//
//  ArticleDetailsViewController.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 31.12.22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ArticleDetailsViewController: UIViewController {
    private let viewModel: ArticleDetailsViewModelOutput & ArticleDetailsViewModelInput
    private let disposeBag = DisposeBag()
    
//MARK: - UI Declaration
    
    private struct Constants {
        static let verticleMargin = 5.0
        static let horizontalMargin = 8.0
    }
    
    private let scrollView = UIScrollView()
    private lazy var stackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = UIStackView.spacingUseSystem
        stack.layoutMargins = UIEdgeInsets(top: Constants.verticleMargin,
                                           left: Constants.horizontalMargin,
                                           bottom: Constants.verticleMargin,
                                           right: Constants.horizontalMargin)
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32.0)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
//MARK: - Initialization
    
    init(viewModel: ArticleDetailsViewModelOutput & ArticleDetailsViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ArticlesListViewController must be initialized using init(viewModel:)")
    }
    
//MARK: - View Model binding
    
    private func bindViewModel() {
        viewModel.articleTitle
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.articleContent
            .asDriver()
            .drive(contentLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.articleImage
            .asDriver()
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    //MARK: - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        bindViewModel()
    }
    
    private func prepareUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [
            .flexibleHeight,
            .flexibleWidth]
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width - Constants.horizontalMargin * 2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)])
    }
}
