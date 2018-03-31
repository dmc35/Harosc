//
//  Api.User.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/9/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.User {
    struct LoginParams {
        let email: String
        let password: String
    }

    @discardableResult
    static func login(params: LoginParams, completion: @escaping Completion) -> Request? {
        api.session.credential = Session.Credential(
            email: params.email,
            pass: params.password
        )

        let path = Api.Path.User.Login()
        var parameters: JSObject = [:]
        parameters[App.String.email] = params.email
        parameters[App.String.password] = params.password

        return api.request(method: .post, urlString: path, parameters: parameters) { (result) in
            Mapper<User>().map(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }

    @discardableResult
    static func getProfileUser(completion: @escaping Completion) -> Request? {
        let path = Api.Path.User.Me()
        return api.request(method: .get, urlString: path) { (result) in
            Mapper<User>().mapRealm(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}

extension Api.User {
    struct RegisterParams {
        let name: String
        let email: String
        let password: String
        let confirm: String
    }

    @discardableResult
    static func register(params: RegisterParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.User.Register()
        var parameters: JSObject = [:]
        parameters[App.String.name] = params.name
        parameters[App.String.email] = params.email
        parameters[App.String.password] = params.password
        parameters[App.String.confirm] = params.confirm

        return api.request(method: .post, urlString: path, parameters: parameters) { (result) in
            Mapper<User>().map(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}

extension Api.User {
    struct UpdateProfileParams {
        let name: String
        let phone: String
        let birthday: String
        let gender: Bool
    }

    struct UpdatePasswordParams {
        let password: String
    }

    struct UpdateAvatarParams {
        let image: UIImage
    }

    @discardableResult
    static func updateProfile(params: UpdateProfileParams, completion: @escaping Completion) -> Request? {
        let path = Api.Path.User.Update()
        var parameters: JSObject = [:]
        parameters[App.String.name] = params.name
        parameters[App.String.phone] = params.phone
        parameters[App.String.birthday] = params.birthday
        parameters[App.String.gender] = params.gender

        return api.request(method: .put, urlString: path, parameters: parameters) { (result) in
            Mapper<User>().map(result: result, type: .object, completion: { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }

    static func apiMultipart(params: UpdateAvatarParams, completion: @escaping Completion) {
        let url = Api.Path.User.Avatar().urlString
        var parameters: JSObject = [:]
        if let imageData = UIImageJPEGRepresentation(params.image, 0.5) {
            parameters["avatar"] = imageData as AnyObject?
            guard let accessToken = api.session.accessToken else { return }
            Alamofire.upload(
                multipartFormData: { (multipartFormData: MultipartFormData) in
                    for (key, value) in parameters where key == "avatar" {
                        guard let data = value as? Data else { return }
                        multipartFormData.append(data, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    }
                },
                usingThreshold: 1,
                to: url,
                method: .patch,
                headers: ["Authorization": "Bearer \(accessToken)"],
                encodingCompletion: { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            Mapper<User>().mapRealm(result: response.result, type: .object, completion: { (result) in
                                DispatchQueue.main.async {
                                    completion(result)
                                }
                            })
                        }
                    case .failure:
                        completion(.failure(Api.Error.network))
                    }
                })
        } else {
            completion(.failure(Api.Error.requestError))
        }
    }
}
