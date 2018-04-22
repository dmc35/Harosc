//
//  GenderView.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/30/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

protocol GenderViewDelegate: class {
    func genderView(_ view: GenderView, needsPerformGender gender: GenderViewModel.Gender)
}

final class GenderView: UIView, MVVM.View {

    // MARK: - Properties
    weak var delegate: GenderViewDelegate?

    // MARK: - IBActions
    @IBAction func maleTouchUpInside(_ sender: UIButton) {
        delegate?.genderView(self, needsPerformGender: .male)
    }

    @IBAction func femaleTouchUpInside(_ sender: UIButton) {
        delegate?.genderView(self, needsPerformGender: .female)
    }

    @IBAction func cancelTouchUpInside(_ sender: UIButton) {
        delegate?.genderView(self, needsPerformGender: .none)
    }
}
