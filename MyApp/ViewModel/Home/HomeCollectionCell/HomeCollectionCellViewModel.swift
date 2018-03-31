//
//  HomeTableCellViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/18/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM

final class HomeCollectionCellViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var data: Datas

    init(data: Datas) {
        self.data = data
    }
}
