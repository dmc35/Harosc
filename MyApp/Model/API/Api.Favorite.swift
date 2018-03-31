//
//  Api.Favorite.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/13/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.Favorite {
    struct FavoriteParams {
        let id: Int
    }

    @discardableResult
    static func listFavorite(completion: @escaping Completion) -> Request? {
        let path = Api.Path.Favorite.ListFavorite()
        return api.request(method: .get, urlString: path) { (result) in
            Mapper<Promotion>().map(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }

    @discardableResult
    static func deleteListFavorite(completion: @escaping Completion) -> Request? {
        let path = Api.Path.Favorite.ListFavorite()
        return api.request(method: .delete, urlString: path) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    @discardableResult
    static func deleteOneFavorite(params: FavoriteParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.Favorite.DeleteOneFavorite(id: params.id)
        return api.request(method: .delete, urlString: path) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    @discardableResult
    static func addFavorite(params: FavoriteParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.Favorite.ListFavorite()
        var parameters: Parameters = [:]
        parameters[App.String.promotionId] = params.id
        return api.request(method: .post, urlString: path, parameters: parameters) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
