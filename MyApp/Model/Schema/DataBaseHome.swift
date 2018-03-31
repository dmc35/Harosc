//
//  DataBaseHome.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/22/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import Foundation

final class DataBaseHome {
    var thumbnail: String
    var title: String
    var coordinate: [Coordonate]
    var rating: String
    var distance: String
    var content: [String]
    var favorite: Bool

    init(thumbnail: String, title: String, coordinate: [Coordonate], rating: String, distance: String, content: [String], favorite: Bool) {
        self.thumbnail = thumbnail
        self.title = title
        self.coordinate = coordinate
        self.rating = rating
        self.distance = distance
        self.content = content
        self.favorite = favorite
    }
}
