//
//  Promotion.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/26/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class Datas: Object, Mappable {
    var id = 0
    var thumImage = ""
    var long = 0.0
    var lat = 0.0
    var address = ""
    var title = ""
    var code = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map[App.String.id]
        thumImage <- map[App.String.thumImage]
        long <- map[App.String.long]
        lat <- map[App.String.lat]
        address <- map[App.String.address]
        title <- map[App.String.title]
        code <- map[App.String.code]
    }

    override static func primaryKey() -> String? {
        return App.String.id
    }
}
