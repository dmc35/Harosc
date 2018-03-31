//
//  SideMenuCellViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/23/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import MVVM

final class SideMenuCellViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var title: String

    init(title: String) {
        self.title = title
    }
}
