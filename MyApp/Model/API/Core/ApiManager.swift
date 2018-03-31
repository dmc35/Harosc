//
//  ApiManager.swift
//  MyApp
//
//  Created by DaoNV on 4/10/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]

typealias Completion = (Result<Any>) -> Void

let api = ApiManager()

final class ApiManager {

    let session = Session()

    var defaultHTTPHeaders: [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        if let accessToken = api.session.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        return headers
    }
}
