//
//  Error.swift
//  MyApp
//
//  Created by DaoNV on 3/7/16.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUtils

typealias Network = NetworkReachabilityManager

// MARK: - Network
extension Network {
    static let shared: Network = {
        guard let manager = Network() else {
            fatalError("Cannot alloc network reachability manager!")
        }
        return manager
    }()
}

extension Api {
    struct Error {
        static let network = NSError(domain: NSCocoaErrorDomain, message: "The internet connection appears to be offline.")
        static let authen = NSError(domain: Api.Path.baseURL.host, status: HTTPStatus.unauthorized)
        static let json = NSError(domain: NSCocoaErrorDomain, code: 3_840, message: "The operation couldn’t be completed.")
        static let apiKey = NSError(domain: Api.Path.baseURL.host, status: HTTPStatus.badRequest)
        static let jsonError = NSError(message: "Json Error")
        static let requestError = NSError(message: "Get Data Error")
        static let loadError = NSError(message: "Can't load data")
        static let uploadError = NSError(message: "Upload File Error")
        static let notChange = NSError(message: "Profile not change")
    }
}

extension Error {
    func show() {
        let `self` = self as NSError
        self.show()
    }

    public var code: Int {
        let `self` = self as NSError
        return self.code
    }
}

extension NSError {
    func show() { }
}
