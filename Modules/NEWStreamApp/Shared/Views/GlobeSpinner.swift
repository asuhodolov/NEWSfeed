//
//  GlobeSpinner.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 6.01.23.
//

import SwiftUI
import CoreFoundation

struct GlobeSpinner: View {
    private struct Constants {
        static let activationSpeed = 4.0
        static let moonToGlobeSizeRatio = 0.25
    }
    
    @EnvironmentObject private var integration: GlobeSpinnerRefreshAnimatable
    @State private var animate = false
    
    private var opacity: Double {
        switch integration.state {
        case .snapshot(let animationPercentage):
            return Double(animationPercentage) * Constants.activationSpeed
        case .animated:
            return 1.0
        }
    }
    
    private var scale: Double {
        switch integration.state {
        case .snapshot(let animationPercentage):
            let scale = Double(animationPercentage) * Constants.activationSpeed
            return min(scale, 1.0)
        case .animated:
            return 1.0
        }
    }
    
    private func moonPosition(for geometry: GeometryProxy) -> CGPoint {
        switch integration.state {
        case .animated:
            return .zero
        case .snapshot(let animationPercentage):
            let center = CGPoint(x: geometry.size.width / 2,
                                 y: geometry.size.height / 2)
            let radius = min(geometry.size.width / 2,
                             geometry.size.height / 2)
                + 2 * moonHeight(for: geometry)
            let angle = -2 * Double.pi * Double(animationPercentage) + Double.pi
            let positionX = sin(angle) * radius
            let positionY = cos(angle) * radius
            return .init(x: center.x + positionX,
                         y: center.y + positionY)
        }
    }
    
    private func moonHeight(for geometry: GeometryProxy) -> Double {
        let spinnerHeight = min(geometry.size.width,
                                geometry.size.height)
        return spinnerHeight / (1 + Constants.moonToGlobeSizeRatio)
    }
    
    private func globeHeight(for geometry: GeometryProxy) -> Double {
        let spinnerHeight = min(geometry.size.width,
                                geometry.size.height)
        return spinnerHeight - moonHeight(for: geometry)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let globeHeight = globeHeight(for: geometry)
                Image("globe")
                    .frame(width: globeHeight,
                           height: globeHeight,
                           alignment: .center)
                
                MoonView()
//                    .offset(y: -40.0)
                    .position(moonPosition(for: geometry))
//                    .rotationEffect(Angle(degrees: animate ? 0.0 : -360.0))
//                    .animation(Animation.linear(duration: 1.0).repeatForever (autoreverses: false),
//                               value: animate)
            }.opacity(opacity)
            .scaleEffect(scale, anchor: .center)
            .onAppear() {
                let _ = integration.$state.sink { state in
                    if case .animated = state {
                        animate = true
                    } else {
                        animate = false
                    }
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GlobeSpinner()
    }
}
