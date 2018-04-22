//
//  MapBranchViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class MapBranchViewModel: MVVM.ViewModel {
    var datas: [Datas]

    init(datas: [Datas] = []) {
        self.datas = datas
    }

    func numberOfItems() -> Int {
        return datas.count
    }

    func viewModelForItem(at index: Int) -> MapItemViewModel {
        let data = datas[index]
        return MapItemViewModel(dataItem: data)
    }
}
