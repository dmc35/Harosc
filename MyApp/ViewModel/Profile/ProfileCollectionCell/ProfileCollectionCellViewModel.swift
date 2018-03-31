//
//  ProfileCollectionCellViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/22/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM

final class ProfileCollectionCellViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var itemFavorite: Datas

    init(_ itemFavorite: Datas) {
        self.itemFavorite = itemFavorite
    }
}
