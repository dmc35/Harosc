//
//  MapItemViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class MapItemViewModel: MVVM.ViewModel {
    var dataItem: Datas

    init(dataItem: Datas) {
        self.dataItem = dataItem
    }
}
