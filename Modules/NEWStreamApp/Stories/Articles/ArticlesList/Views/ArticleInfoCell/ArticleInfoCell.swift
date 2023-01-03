//
//  ArticleInfoCell.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class ArticleInfoCell: UITableViewCell {
    static let reusableIdentifier = "ImageInfoCellIdentifier"
    var disposeBag = DisposeBag()
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.contentMode = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.contentMode = .left
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    //MARK: - UI
    
    private func prepareViews() {
        prepareImageView()
        prepareTitleLabel()
        prepareDetailsLabel()
    }
    
    private func prepareImageView() {
        contentView.addSubview(contentImageView)
        NSLayoutConstraint.activate([
            contentImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentImageView.heightAnchor.constraint(equalTo: contentImageView.widthAnchor),
        ])
    }
    
    private func prepareTitleLabel() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: contentView.layoutMargins.left),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -contentView.layoutMargins.right),
            titleLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor,
                                            constant: 10.0)
        ])
    }
    
    private func prepareDetailsLabel() {
        contentView.addSubview(detailsLabel)
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: contentView.layoutMargins.left),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -contentView.layoutMargins.right),
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                              constant: 8.0),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -8.0)
        ])
    }
    
    //MARK: - Model
    
    func bind(to viewModel: ArticleInfoCellViewModel) {
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.details.asDriver().drive(detailsLabel.rx.text).disposed(by: disposeBag)
        viewModel.image.asDriver().filterNil().drive(contentImageView.rx.image).disposed(by: disposeBag)
    }
}
