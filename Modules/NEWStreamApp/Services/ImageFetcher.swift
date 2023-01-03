//
//  ImageFetcher.swift
//  NEWStream
//
//  Created by Aliaksandr Sukhadolau on 26.12.22.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

public final class ImageFetcher {
    static let imageRequestsCache = NSCache<NSString, NSData>()
    
    public func loadImage(url: URL) -> Single<UIImage?> {
        return Single<UIImage?>.create { single in
            if let cachedData = ImageFetcher.imageRequestsCache.object(forKey: url.absoluteString as NSString) {
                single(.success(UIImage(data:cachedData as Data)))
                return Disposables.create()
            }
            
            return URLSession.shared.rx
                .response(request: URLRequest(url: url))
                .subscribe { (response: HTTPURLResponse, data: Data) in
                    ImageFetcher.imageRequestsCache.setObject(data as NSData,
                                                              forKey: url.absoluteString as NSString)
                    single(.success(UIImage(data: data)))
                } onError: { error in
                    single(.failure(error))
                }
        }
    }
}
