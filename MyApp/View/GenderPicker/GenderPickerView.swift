//
//  Picker.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/8/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

protocol GenderPickerViewDelegate: class {
    func genderPicker(_ view: GenderPickerView, needsPerformText text: String)
}

final class GenderPickerView: UIView, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var genderPicker: UIPickerView!
    @IBOutlet fileprivate weak var outsizeView: UIView!

    // MARK: - Properites
    weak var delegate: GenderPickerViewDelegate?

    var viewModel = PickerViewModel()

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        initEvent()
    }

    // MARK: - Private
    private func initEvent() {
        genderPicker.dataSource = self
        genderPicker.delegate = self

        let tapGestureOutsize = UITapGestureRecognizer(target: self, action: #selector (pressOutsize))
        outsizeView.isUserInteractionEnabled = true
        outsizeView.addGestureRecognizer(tapGestureOutsize)
    }

    // MARK: - objc
    @objc func pressOutsize() {
        removeFromSuperview()
    }
}

// MARK: - UIPickerView DataSource
extension GenderPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent(component)
    }
}

// MARK: - UIPickerView Delegate
extension GenderPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textGender = viewModel.pickDataRow(row)
        delegate?.genderPicker(self, needsPerformText: textGender)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickDataRow(row)
    }
}
