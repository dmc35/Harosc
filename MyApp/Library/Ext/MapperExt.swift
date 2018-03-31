//
//  Mapper.swift
//  MyApp
//
//  Created by DaoNV on 3/17/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import Alamofire
import RealmSwift
import ObjectMapper

enum DataType {
    case object
    case array
}

extension Mapper where N: Object, N: Mappable {
    func mapRealm(result: Result<Any>, type: DataType, completion: Completion) {
        switch result {
        case .success(let json):
            switch type {
            case .object:
                guard let obj = json as? JSObject else {
                    completion(.failure(Api.Error.json))
                    return
                }
                do {
                    let realm = try Realm()
                    try realm.write {
                        if let object = Mapper<N>().map(JSON: obj) {
                            realm.add(object, update: true)
                        }
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
                completion(.success(json))
            case .array:
                guard let objs = json as? JSArray else {
                    completion(.failure(Api.Error.json))
                    return
                }
                do {
                    let realm = try Realm()
                    try realm.write {
                        let objects = Mapper<N>().mapArray(JSONArray: objs)
                        realm.add(objects)
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
                completion(.success(json))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func map(result: Result<Any>, type: DataType, completion: Completion) {
        switch result {
        case .success(let json):
            switch type {
            case .object:
                guard let obj = json as? JSObject else {
                    completion(.failure(Api.Error.json))
                    return
                }
                if let object = Mapper<N>().map(JSON: obj) {
                    completion(.success(object))
                }
            case .array:
                guard let objs = json as? JSArray else {
                    completion(.failure(Api.Error.json))
                    return
                }
                let objects = Mapper<N>().mapArray(JSONArray: objs)
                completion(.success(objects))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
