//
//  DetailPromotion.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/27/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers
final class DetailPromotion: Object, Mappable {
    var id = 0
    var content = ""
    var long = 0.0
    var lat = 0.0
    var address = ""
    var title = ""
    var code = ""
    var thumImage = ""
    var images = List<Thumbnail>()
    var menuImages = List<Thumbnail>()

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map[App.String.id]
        images <- map[App.String.images]
        menuImages <- map[App.String.menuImages]
        content <- map[App.String.content]
        long <- map[App.String.long]
        lat <- map[App.String.lat]
        address <- map[App.String.address]
        title <- map[App.String.title]
        code <- map[App.String.code]
        thumImage <- map[App.String.thumImage]
    }

    override static func primaryKey() -> String? {
        return App.String.id
    }

    static func query(id: Int) -> DetailPromotion? {
        do {
            let realm = try Realm()
            return realm.object(ofType: DetailPromotion.self, forPrimaryKey: id)
        } catch {
            print(error)
        }
        return nil
    }
}
