//
//  ProfileEditViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/17/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import UIKit
import MVVM
import RealmSwift

final class ProfileEditViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum ProfileResult {
        case success
        case failure
    }

    enum FieldType: Int {
        case phone
        case birthDay
        case gender

        var placeholder: String {
            switch self {
            case .phone:
                return "Số điện thoại"
            case .birthDay:
                return "Ngày sinh"
            case .gender:
                return "Giới tính"
            }
        }
    }

    enum SectionType: Int {
        case field
        case button

        var rows: [FieldType] {
            switch self {
            case .field:
                return [.phone, .birthDay, .gender]
            case .button:
                return []
            }
        }
    }

    let title = App.String.kEditProfile
    var fieldTypes: [FieldType] = [.phone, .birthDay, .gender]
    var sectionTypes: [SectionType] = [.field, .button]
    var phone = ""
    var birthday = ""
    var gender: Bool?
    var image: UIImage?

    // MARK: - Public
    func numberOfSections() -> Int {
        return sectionTypes.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        let sectionType = sectionTypes[section]
        switch sectionType {
        case .field:
            return sectionType.rows.count
        case .button:
            return 1
        }
    }

    func getIndexPathOfField(fieldType: FieldType) -> IndexPath {
        let indexPath = IndexPath(row: fieldType.rawValue, section: 0)
        return indexPath
    }

    func textFieldForRow(indexPath: IndexPath) -> FieldType {
        let textField = fieldTypes[indexPath.row]
        return textField
    }

    func viewModelForItem(at indexPath: IndexPath) -> ViewModel {
        let sectionType = sectionTypes[indexPath.section]
        switch sectionType {
        case .field:
            let fieldType = sectionType.rows[indexPath.row]
            return ProfileEditFieldCellViewModel(user: user, fieldType: fieldType)
        case .button:
            return ProfileEditButtonCellViewModel()
        }
    }

    func reloadRowTableView(tableView: UITableView, fieldType: FieldType) {
        let indexPath = getIndexPathOfField(fieldType: fieldType)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func dateFormat(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = App.String.dateFormat
        return dateFormat.string(from: date)
    }

    func isValidEmail(_ testEmail: String?) -> String? {
        return nil
    }

    func isValidPassword(_ testPass: String, _ testConfirm: String?) -> String? {
        return nil
    }

    func isValidBirthGender(_ testBirth: String, _ testGender: String) -> String? {
        return nil
    }

    // MARK: - processEditProfile
    func uploadAvatar(completion: @escaping (ProfileResult) -> Void) {
        if let image = image {
            let params = Api.User.UpdateAvatarParams(image: image)
            Api.User.apiMultipart(params: params) { (result) in
                switch result {
                case .success:
                   completion(.success)
                case .failure:
                    completion(.failure)
                }
            }
        } else {
            completion(.failure)
        }
    }
}
