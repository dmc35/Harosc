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
    enum Validation: CustomStringConvertible {
        case success
        case failure(String)

        var description: String {
            switch self {
            case .success:
                return "Thành công"
            case .failure(let msg):
                return "Thất bại: " + msg
            }
        }
    }

    enum ProfileResult {
        case success
        case failure(String)
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
    var sectionTypes: [SectionType] = [.field, .button]
    var name = ""
    var phone = ""
    var birthday = ""
    var gender = true
    var image: UIImage?
    var isEditingChanged = false

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

    func getUser() {
        name = user.name
        phone = user.phone
        birthday = user.birthday
        gender = user.gender
    }

    func avatarChanged(imageChoose: UIImage?) {
        image = imageChoose
        isEditingChanged = true
    }

    func fieldEditingChanged(fieldType: FieldType? = nil, text: String) {
        guard let fieldType = fieldType else {
            name = text
            isEditingChanged = true
            return
        }
        switch fieldType {
        case .phone:
            phone = text
        case .birthDay:
            birthday = text
        case .gender:
            if text == App.String.kMale {
                gender = true
            } else {
                gender = false
            }
        }
        isEditingChanged = true
    }

    func checkValidate() -> Validation {
        guard !name.isEmpty else {
            return .failure(App.String.kEmpty)
        }
        guard !phone.isEmpty else {
            return .failure(App.String.kEmpty)
        }
        return .success
    }

    // MARK: - processEditProfile
    func updateProfile(completion: @escaping (ProfileResult) -> Void) {
        let profileParams = Api.User.UpdateProfileParams(name: name,
                                                         phone: phone,
                                                         birthday: birthday,
                                                         gender: gender)
        if isEditingChanged {
            Api.User.updateProfile(params: profileParams) { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success:
                    if let image = this.image {
                        let params = Api.User.UpdateAvatarParams(image: image)
                        Api.User.apiMultipart(params: params) { (result) in
                            switch result {
                            case .success:
                                completion(.success)
                            case .failure:
                                completion(.failure(App.String.kUpdateError))
                            }
                            return
                        }
                    }
                    completion(.success)
                case .failure:
                    completion(.failure(App.String.kUpdateError))
                }
            }
        } else {
            completion(.failure(App.String.kUpdateEmpty))
        }
    }
}
