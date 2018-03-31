//
//  Thumbnail.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/27/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers
final class Thumbnail: Object, Mappable {
    var url = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        url <- map[App.String.url]
    }

    override static func primaryKey() -> String? {
        return App.String.url
    }
}
