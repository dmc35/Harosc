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
        configGenderView()
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

    private func configGenderView() {
        genderView.delegate = self
        genderView.frame = CGRect(x: 0, y: 0, width: Config.width, height: Config.heightPicker)
    }

    @IBAction func fieldCellEditingChanged(_ sender: UITextField) {
        delegate?.editFieldCell(self, needsPerformAction: .endEdit(text: fieldCellTextField.text), fieldType: .phone)
    }

    // MARK: - objc Private
    @objc private func valueDateChange() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = App.String.dateFormat
        let text = dateFormatter.string(from: datePicker.date)
        fieldCellTextField.text = text
        delegate?.editFieldCell(self, needsPerformAction: .endEdit(text: fieldCellTextField.text), fieldType: .birthDay)
    }
}

// MARK: - GenderView Delegate
extension ProfileEditFieldCell: GenderViewDelegate {
    func genderView(_ view: GenderView, needsPerformGender gender: GenderViewModel.Gender) {
        switch gender {
        case .male:
            fieldCellTextField.text = gender.title
        case .female:
            fieldCellTextField.text = gender.title
        case .none:
            break
        }
        fieldCellTextField.resignFirstResponder()
        delegate?.editFieldCell(self, needsPerformAction: .endEdit(text: fieldCellTextField.text), fieldType: .gender)
    }
}

extension ProfileEditFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let viewModel = viewModel else { return false }
        delegate?.editFieldCell(self, needsPerformAction: .endEdit(text: fieldCellTextField.text), fieldType: viewModel.fieldType)
        return true
    }
}
