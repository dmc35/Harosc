//
//  DetailImageCellViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class DetailImageCellViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var launchUrl = ""
    var launchNumber = 0
    var menuUrl = ""
    var menuNumber = 0

    init(launchUrl: String, launchNumber: Int, menuUrl: String, menuNumber: Int) {
        self.launchUrl = launchUrl
        self.menuUrl = menuUrl
        self.launchNumber = launchNumber
        self.menuNumber = menuNumber
    }
}
