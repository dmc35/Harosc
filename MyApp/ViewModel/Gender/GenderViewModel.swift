//
//  GenderViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/3/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class GenderViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum Gender {
        case male
        case female
        case none

        var title: String? {
            switch self {
            case .male:
                return App.String.kMale
            case .female:
                return App.String.kFemale
            case .none:
                return nil
            }
        }
    }
}
