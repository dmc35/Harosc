//
//  ResponseSerializer.swift
//  MyApp
//
//  Created by DaoNV on 3/7/16.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import Alamofire
import RealmSwift
import ObjectMapper
import SwiftUtils

extension Request {
    static func responseJSONSerializer(log: Bool = true,
                                       response: HTTPURLResponse?,
                                       data: Data?,
                                       error: Error?) -> Result<Any> {
        guard let response = response else {
            return .failure(NSError(status: .noResponse))
        }

        if let error = error {
            return .failure(error)
        }

        let statusCode = response.statusCode

        if 204...205 ~= statusCode { // empty data status code
            return .success([:])
        }

        guard 200...299 ~= statusCode else {
            var err: NSError!
            if let json = data?.toJSON() as? JSObject,
                let errors = json["errors"] as? JSArray,
                !errors.isEmpty,
                let message = errors[0]["value"] as? String {
                err = NSError(message: message)
            } else if let status = HTTPStatus(code: statusCode) {
                err = NSError(domain: Api.Path.baseURL.host, status: status)
            } else {
                err = NSError(domain: Api.Path.baseURL.host,
                              code: statusCode,
                              message: "Unknown HTTP status code received (\(statusCode)).")
            }

            return .failure(err)
        }

        guard let data = data, let json = data.toJSON() else {
            return Result.failure(Api.Error.json)
        }

        return .success(json)
    }
}

extension DataRequest {
    static func responseSerializer() -> DataResponseSerializer<Any> {
        return DataResponseSerializer { _, response, data, error in
            return Request.responseJSONSerializer(log: true,
                                                  response: response,
                                                  data: data,
                                                  error: error)
        }
    }

    @discardableResult
    func responseJSON(queue: DispatchQueue = .global(qos: .background),
                      completion: @escaping (DataResponse<Any>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.responseSerializer(),
                        completionHandler: completion)
    }
}
