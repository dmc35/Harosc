//
//  Comment.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/16/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class Comment: Object, Mappable {

    var id = 0
    var date = ""
    var content = ""
    var userAvatarUrl = ""
    var userId = 0
    var userName = ""

    convenience required init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map[App.String.id]
        date <- map[App.String.date]
        content <- map[App.String.content]
        userAvatarUrl <- map[App.String.userAvatarUrl]
        userId <- map[App.String.userId]
        userName <- map[App.String.userName]
    }

    override static func primaryKey() -> String? {
        return App.String.id
    }
}
