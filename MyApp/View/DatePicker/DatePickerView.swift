//
//  DatePicker.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 12/7/17.
//  Copyright © 2017 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM

protocol DatePickerViewDelegate: class {
    func datePicker(_ view: DatePickerView, needsPerformAction action: DatePickerView.Action)
}

final class DatePickerView: UIView, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var datePicker: UIDatePicker!
    @IBOutlet fileprivate weak var outsizeView: UIView!

    // MARK: - Properties
    enum Action {
        case valueDate(date: Date)
        case cancelBT
        case doneBT(date: Date)
    }

    weak var delegate: DatePickerViewDelegate?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.datePickerMode = .date
        actionInit()
    }

    // MARK: - Private
    func actionInit() {
        let tapGestureOutsize = UITapGestureRecognizer(target: self, action: #selector (pressOutsize))
        outsizeView.isUserInteractionEnabled = true
        outsizeView.addGestureRecognizer(tapGestureOutsize)

        datePicker.addTarget(self, action: #selector (valueDateChange), for: .valueChanged)
    }

    // MARK: - objc
    @objc func pressOutsize() {
        delegate?.datePicker(self, needsPerformAction: .cancelBT)
        removeFromSuperview()
    }

    @objc func valueDateChange(value: UIDatePicker) {
        delegate?.datePicker(self, needsPerformAction: .valueDate(date: value.date))
    }

    // MARK: - IBActions
    @IBAction func pressCancelButton(_ sender: UIButton) {
        delegate?.datePicker(self, needsPerformAction: .cancelBT)
        removeFromSuperview()
    }

    @IBAction func pressDoneButton(_ sender: UIButton) {
        delegate?.datePicker(self, needsPerformAction: .doneBT(date: datePicker.date))
        removeFromSuperview()
    }
}
