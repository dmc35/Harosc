//
//  DetailCollectionCellViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/27/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class DetailCollectionCellViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var imageUrl = ""

    init(url: String) {
        self.imageUrl = url
    }
}
