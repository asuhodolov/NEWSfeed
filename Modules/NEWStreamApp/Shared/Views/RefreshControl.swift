//
//  File.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 5.01.23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public enum RefreshAnimatableState {
    case snapshot(animationPercentage: Float)
    case animated
}

public protocol RefreshAnimatable {
    var state: RefreshAnimatableState { get set }
    var representingView: UIView { get }
}

public final class RefreshControl: UIView {
    private enum State {
        case hidden
        case animating
        case activationProgress(animationPercentage: Float)
    }
    
    public struct Config {
        public let pullDistance: Float
        public let rotationSpeed: Float
        public let indicatorSize: CGSize
        
        public init(pullDistance: Float,
                    rotationSpeed: Float,
                    indicatorSize: CGSize) {
            self.pullDistance = pullDistance
            self.rotationSpeed = rotationSpeed
            self.indicatorSize = indicatorSize
        }
    }
    
    public let onRefresh = PublishSubject<Void>()
    private var refreshViewController: RefreshAnimatable
    private let config: Config
    private var state: State = .hidden {
        didSet {
            switch state {
            case .hidden:
                refreshViewController.representingView.isHidden = true
                refreshViewController.state = .snapshot(animationPercentage: 0.0)
            case .animating:
                refreshViewController.representingView.isHidden = false
                refreshViewController.state = .animated
            case .activationProgress(let animationPercentage):
                refreshViewController.representingView.isHidden = false
                refreshViewController.state = .snapshot(animationPercentage: animationPercentage)
            }
        }
    }
    private var disposeBag = DisposeBag()
    
    public init(refreshViewController: some RefreshAnimatable,
         config: Config = Config(pullDistance: 200.0,
                                 rotationSpeed: 1.0,
                                 indicatorSize: .init(width: 20.0, height: 20.0))) {
        self.refreshViewController = refreshViewController
        self.config = config
        super.init(frame: .init(origin: CGPointZero,
                                size: config.indicatorSize))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startRefreshing() {
        state = .animating
    }
    
    public func stopRefreshing() {
        state = .hidden
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        disposeBag = DisposeBag()

        guard let scrollView = superview as? UIScrollView else { return }
        
        addRefreshView(to: scrollView)
        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self, weak scrollView] offset in
                guard let self = self,
                    let scrollView = scrollView
                else { return }
                
                self.processPull(with: -Float(offset.y + scrollView.safeAreaInsets.top),
                                 in: scrollView)
            }).disposed(by: disposeBag)
    }
    
    private func addRefreshView(to scrollView: UIScrollView) {
        state = .hidden
        refreshViewController.representingView.isHidden = true
        refreshViewController.state = .snapshot(animationPercentage: 0.0)
        
        scrollView.addSubview(refreshViewController.representingView)
        refreshViewController.representingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshViewController.representingView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            refreshViewController.representingView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -20.0),
            refreshViewController.representingView.heightAnchor.constraint(equalToConstant: config.indicatorSize.height),
            refreshViewController.representingView.widthAnchor.constraint(equalToConstant: config.indicatorSize.width)])
    }
    
    private func processPull(with offset: Float,
                             in scrollView: UIScrollView) {
        if case .animating = state { return }
        
        guard offset > 0 else {
            state = .hidden
            return
        }
        
        guard offset > config.pullDistance else {
            let activationProgress = Float(scrollView.contentOffset.y) / config.pullDistance
            state = .activationProgress(animationPercentage: activationProgress)
            return
        }
        
        state = .animating
        onRefresh.onNext(())
    }
}


extension Reactive where Base: RefreshControl {
    public var isRefreshing: Binder<Bool> {
        return Binder(self.base) { refreshControl, refresh in
            if refresh {
                refreshControl.startRefreshing()
            } else {
                refreshControl.stopRefreshing()
            }
        }
    }

}
