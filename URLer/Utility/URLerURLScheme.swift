////
////  URLerURLScheme.swift
////  URLer
////
////  Created by Joel Whitney on 2/15/18.
////  Copyright © 2018 Joel Whitney. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//public final class URLerURLScheme {
//
//    public static let scheme = "arcgis-urler://"
//
//    public static var canOpen: Bool {
//        return UIApplication.shared.canOpenURL(URL(string: scheme)!)
//    }
//
//    fileprivate struct AppLinkSchema {
//        fileprivate static let CallingAppKey = "callingApp"
//    }
//}
//
//public final class URLerURLQueryItems {
//    fileprivate typealias Scheme = URLerURLScheme.AppLinkSchema
//
//    private let queryItems: [URLQueryItem]
//
//    public lazy var callingApp: String? = {
//        return self.queryItems[Scheme.CallingAppKey]
//    }()
//
//
//    public init?(url: URL) {
//        guard let queryItems = URLerURLQueryItems.urlComponents(of: url)?.queryItems else {
//            return nil
//        }
//
//        self.queryItems = queryItems
//    }
//
//    private class func urlComponents(of url: URL) -> URLComponents? {
//        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//            return nil
//        }
//
//        // Manually encode "+" as a percent-encoded space character so that URLComponents decodes it automatically when
//        // generating `queryItems`.
//        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?
//            .replacingOccurrences(of: "+", with: "%20")
//
//        return urlComponents
//    }
//}
//
//
////extension URLComponents {
////    public var queryItems: [String: String] {
////        var params = [String: String]()
////        queryItems.forEach { item in
////            params[item.name] = item.value
////        }
////        return params
////    }
////}
//
