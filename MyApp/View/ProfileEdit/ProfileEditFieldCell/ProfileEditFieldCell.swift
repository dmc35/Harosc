//
//  ProfileEditFieldCell.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/16/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

protocol ProfileEditFieldCellDelegate: class {
    func editFieldCell(_ view: ProfileEditFieldCell, needsPerformAction action: ProfileEditFieldCell.Action, fieldType: ProfileEditViewModel.FieldType)
}

final class ProfileEditFieldCell: UITableViewCell, MVVM.View {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var fieldCellTextField: UITextField!

    // MARK: - Properties
    private struct Config {
        static let width = UIScreen.main.bounds.width
        static let heightDatePicker: CGFloat = 216
        static let heightPicker: CGFloat = 100
    }

    enum Action {
        case endEdit(text: String?)
        case cancel
    }

    var viewModel: ProfileEditFieldCellViewModel? {
        didSet {
            updateView()
        }
    }

    weak var delegate: ProfileEditFieldCellDelegate?

    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let genderView: GenderView = GenderView.loadNib()

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configDatePickerView()
        configPickerView()
    }

    func updateView() {
        guard let viewModel = viewModel else { return }
        let fieldType = viewModel.fieldType
        let text: String
        switch fieldType {
        case .phone:
            fieldCellTextField.keyboardType = .numberPad
            fieldCellTextField.returnKeyType = .next
            text = viewModel.user.phone
        case .birthDay:
            fieldCellTextField.returnKeyType = .next
            fieldCellTextField.inputView = datePicker
            fieldCellTextField.inputAccessoryView = toolBar
            text = viewModel.user.birthday
        case .gender:
            fieldCellTextField.returnKeyType = .done
            fieldCellTextField.inputView = genderView
            if viewModel.user.gender == true {
                text = App.String.kMale
            } else {
                text = App.String.kFemale
            }
        }
        fieldCellTextField.placeholder = fieldType.placeholder
        fieldCellTextField.text = text
    }

    // MARK: - Private func
    private func configDatePickerView() {
        datePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Config.heightDatePicker)
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector (valueDateChange), for: .valueChanged)
    }

    private func configPickerView() {
        genderView.frame = CGRect(x: 0, y: 0, width: Config.width, height: Config.heightPicker)
    }

    // MARK: - objc Private
    @objc private func valueDateChange() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = App.String.dateFormat
        let text = dateFormatter.string(from: datePicker.date)
        fieldCellTextField.text = text
    }
}

// MARK: - UIPickerView DataSource
extension ProfileEditFieldCell: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = viewModel else { fatalError() }
        return viewModel.numberOfRowsInComponent(component)
    }
}

// MARK: - UIPickerView Delegate
extension ProfileEditFieldCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let viewModel = viewModel else { return }
        let text = viewModel.pickDataRow(row)
        fieldCellTextField.text = text
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = viewModel else { fatalError() }
        return viewModel.pickDataRow(row)
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let viewModel = viewModel else { fatalError() }
        let titleRow = viewModel.pickDataRow(row)
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: App.Color.mainColor]
        return NSAttributedString(string: titleRow, attributes: attributes)
    }
}

extension ProfileEditFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let viewModel = viewModel else { return false }
        delegate?.editFieldCell(self, needsPerformAction: .endEdit(text: fieldCellTextField.text), fieldType: viewModel.fieldType)
        return true
    }
}
