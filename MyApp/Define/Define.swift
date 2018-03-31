//
//  KeyText.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/12/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift

let userDefault = UserDefaults.standard

public func <- <T: Object>(left: List<T>, right: Map) where T: BaseMappable {
    if right.mappingType == MappingType.fromJSON {
        if !right.isKeyPresent { return }
        left.removeAll()
        guard let json = right.currentValue as? [[String: Any]] else { return }
        let objects: [T]? = Mapper<T>().mapArray(JSONArray: json)
        guard let objs = objects else { return }
        left.append(objectsIn: objs)
    } else {
        var _left = left
        _left <- (right, ListTransform<T>())
    }
}

final class ListTransform<T: Object>: TransformType where T: BaseMappable {
    func transformFromJSON(_ value: Any?) -> List<T>? {
        return nil
    }

    func transformToJSON(_ value: List<T>?) -> Any? {
        guard let list = value else { return NSNull() }
        var json: [[String: Any]] = []
        let mapper = Mapper<T>()
        for obj in list {
            json.append(mapper.toJSON(obj))
        }
        return json
    }
}
