//
//  GlobeSpinner+UIKit.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 8.01.23.
//

import Foundation
import UIKit
import SwiftUI

class GlobeSpinnerRefreshAnimatable: ObservableObject {
    @Published var state: RefreshAnimatableState = .snapshot(animationPercentage: 0.0)
}

public class GlobeSpinnerViewController: UIHostingController<AnyView>, RefreshAnimatable {
    public var representingView: UIView { view! }
    public var state: RefreshAnimatableState = .snapshot(animationPercentage: 0.0) {
        didSet {
            integration.state = state
        }
    }
    
    let integration = GlobeSpinnerRefreshAnimatable()

    public init() {
        super.init(rootView: AnyView(GlobeSpinner().environmentObject(integration)))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
