//
//  PickerViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/18/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM

final class PickerViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var pickerData: [String] = ["App.String.kMale", "App.String.kFemale", "App.String.kNone"]

    // MARK: - Public
    func numberOfRowsInComponent(_ component: Int) -> Int {
        return pickerData.count
    }

    func pickDataRow(_ row: Int) -> String {
        return pickerData[row]
    }
}
