//
//  Api.Promotion.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/26/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.Promotion {
    struct PromotionParams {
        let limit: Int
        let page: Int
    }

    struct DetailPromotionParams {
        let id: Int
    }

    @discardableResult
    static func listPromotion(params: PromotionParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.Promotion.ListPromotion()
        var parameters: Parameters = [:]
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

    @discardableResult
    static func detailPromotion(params: DetailPromotionParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.Promotion.DetailPromotion(id: params.id)
        return api.request(method: .get, urlString: path) { (result) in
            Mapper<DetailPromotion>().map(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}
