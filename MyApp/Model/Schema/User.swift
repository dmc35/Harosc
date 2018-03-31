//
//  DataBaseHome.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/14/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class User: Object, Mappable {

    dynamic var id = 0
    dynamic var email = ""
    dynamic var name = ""
    var password = ""
    var confirmPassword = ""
    dynamic var avatarUrl = ""
    dynamic var birthday = ""
    dynamic var gender = true
    dynamic var phone = ""
    var token = ""

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map[App.String.id]
        email <- map[App.String.email]
        name <- map[App.String.name]
        token <- map[App.String.token]
        phone <- map[App.String.phone]
        birthday <- map[App.String.birthday]
        gender <- map[App.String.gender]
        avatarUrl <- map[App.String.avatarUrl]
    }

    override static func primaryKey() -> String? {
        return App.String.id
    }

    static func queryFollowPrimarykey(id: Int) -> User? {
        do {
            let realm = try Realm()
            let object = realm.object(ofType: User.self, forPrimaryKey: id)
            return object
        } catch {
            print(error)
        }
        return nil
    }

    static func queryDeleteUser() {
        do {
            let realm = try Realm()
            let objects = realm.objects(User.self)
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error)
        }
    }
}
