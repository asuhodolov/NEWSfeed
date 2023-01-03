//
//  Services.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import Foundation

public final class Services {
    public lazy var imageFetcher = ImageFetcher()
    public lazy var articlesProvider = NewsStreamProvider()
    
    public init() {}
}
