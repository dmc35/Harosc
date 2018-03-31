//
//  Datas.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/6/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class Promotion: Object, Mappable {

    var currentPage = 0
    var totalPage = 0
    var datas = List<Datas>()

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        currentPage <- map[App.String.currentPage]
        totalPage <- map[App.String.totalPage]
        datas <- map[App.String.datas]
    }
}
