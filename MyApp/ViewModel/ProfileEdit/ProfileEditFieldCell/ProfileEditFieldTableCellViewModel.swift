//
//  ProfileEditTextFieldCellViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/22/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM

final class ProfileEditFieldCellViewModel: MVVM.ViewModel {

    // MARK: - Properties
    var user: User
    var fieldType: ProfileEditViewModel.FieldType

    init(user: User, fieldType: ProfileEditViewModel.FieldType) {
        self.user = user
        self.fieldType = fieldType
    }

    var pickerData: [String] = [App.String.kMale, App.String.kFemale]

    // MARK: - Public
    func numberOfRowsInComponent(_ component: Int) -> Int {
        return pickerData.count
    }

    func pickDataRow(_ row: Int) -> String {
        return pickerData[row]
    }
}
