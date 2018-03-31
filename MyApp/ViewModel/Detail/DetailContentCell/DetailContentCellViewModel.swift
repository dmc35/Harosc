//
//  DetailContentCellViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/28/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class DetailContentCellViewModel: MVVM.ViewModel {

    // Properties
    var title = ""
    var content = ""

    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
