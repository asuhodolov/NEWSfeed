//
//  GlobeSpinner.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 6.01.23.
//

import SwiftUI

struct GlobeSpinner: View {
    @EnvironmentObject private var integration: GlobeSpinnerRefreshAnimatable
    
    var body: some View {
        Image("globe")
            .padding(30.0)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GlobeSpinner()
    }
}
