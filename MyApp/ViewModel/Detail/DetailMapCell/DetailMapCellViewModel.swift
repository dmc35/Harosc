//
//  MapCellViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/19/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MapKit
import MVVM

final class DetailMapCellViewModel: MVVM.ViewModel {

    // MARK: Properties
    var lat = 0.0
    var long = 0.0
    var title = ""
    var subtitle = ""
    var id = 0

    init(detailPromotion: DetailPromotion) {
        self.lat = detailPromotion.lat
        self.long = detailPromotion.long
        self.title = detailPromotion.title
        self.subtitle = detailPromotion.address
        self.id = detailPromotion.id
    }
}
