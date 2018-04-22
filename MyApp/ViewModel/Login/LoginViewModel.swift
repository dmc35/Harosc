//
//  LoginViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/17/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM
import SwiftUtils

final class LoginViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum Field: String {
        case email
        case password
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

    enum LoginResult {
        case success
        case failure(String)
    }

    let title = App.String.kLogin
    var email = "cuong.doan@asiantech.vn"
    var password = "123123"

    // MARK: - Public
    func checkValidate() -> Validation {
        guard !email.isEmpty else {
            return .failure(field: .email, msg: App.String.kEmpty)
        }
        guard !password.isEmpty else {
            return .failure(field: .email, msg: App.String.kEmpty)
        }
        guard email.validate(String.Regex.Email1) else {
            return .failure(field: .email, msg: App.String.kEmailError)
        }
        return .success
    }

    func trimString(_ stringOne: String, _ stringTwo: String) {
        email = stringOne.trimmed
        password = stringTwo.trimmed
    }

    // MARK: - processLogin
    func processLogin(completion: @escaping (LoginResult) -> Void) {
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
