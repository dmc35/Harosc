//
//  Api.Search.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/6/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Alamofire
import ObjectMapper

extension Api.Search {
    struct SearchParams {
        let keyword: String
        let limit: Int
        let page: Int
    }

    @discardableResult
    static func listPromotion(params: SearchParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.Search.Promotion()
        var parameters: Parameters = [:]
        parameters[App.String.keyword] = params.keyword
        parameters[App.String.limit] = params.limit
        parameters[App.String.page] = params.page

        return api.request(method: .get, urlString: path, parameters: parameters) { (result) in
            Mapper<Promotion>().map(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}
