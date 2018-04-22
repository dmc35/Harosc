//
//  RegisterViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/17/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM

final class RegisterViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum Field: String {
        case username
        case email
        case password
        case confirm
    }

    enum Validation: CustomStringConvertible {
        case success
        case failure(field: Field, msg: String)

        var description: String {
            switch self {
            case .success:
                return "Thành công"
            case .failure(_, let msg):
                return "Thất bại: " + msg
            }
        }
    }

    enum RegisterResult {
        case success
        case failure(String)
    }

    var name = ""
    var email = ""
    var password = ""
    var confirm = ""

    // MARK: - Public
    func checkValidate() -> Validation {
        guard !name.isEmpty else {
            return .failure(field: .username, msg: App.String.kEmpty)
        }
        guard !email.isEmpty else {
            return .failure(field: .email, msg: App.String.kEmpty)
        }
        guard !(password.count < 5 || password.count > 20) else {
            return .failure(field: .password, msg: App.String.kPassword)
        }
        guard !(confirm != password) else {
            return .failure(field: .confirm, msg: App.String.kConfirm)
        }
        guard email.validate(String.Regex.Email1) else {
            return .failure(field: .email, msg: App.String.kEmailError)
        }
        return .success
    }

    func trimString(_ stringOne: String, _ stringTwo: String, _ stringThree: String, _ stringFour: String) {
        name = stringOne.trimmed
        email = stringTwo.trimmed
        password = stringThree.trimmed
        confirm = stringFour.trimmed
    }

    // MARK: - ProcessRegister
    func processRegister(completion: @escaping (RegisterResult) -> Void) {
        let params = Api.User.RegisterParams(name: name, email: email, password: password, confirm: confirm)
        Api.User.register(params: params) { (result) in
            switch result {
            case .success:
                completion(.success)
            case .failure:
                completion(.failure(App.String.kRegisterError))
            }
        }
    }

    func processLogin(completion: @escaping (RegisterResult) -> Void) {
        let params = Api.User.LoginParams(email: email, password: password)
        Api.User.login(params: params) { (result) in
            switch result {
            case .success(let value):
                if let value = value as? User {
                    api.session.accessToken = value.token
                }
                completion(.success)
            case .failure:
                completion(.failure(App.String.kLoginError))
            }
        }
    }
}
