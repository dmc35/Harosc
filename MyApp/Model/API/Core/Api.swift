//
//  Api.swift
//  MyApp
//
//  Created by DaoNV on 4/10/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class Api {
    struct Path {
        static let baseURL = "http://54.221.147.79:8080"
        static let version = "v1"
    }

    struct User {
    }

    struct Promotion {
    }

    struct Search {
    }

    struct Favorite {
    }
}

extension Api.Path {
    struct User {
        static var pathUser: String { return baseURL / version / "user" }
    }

    struct Promotion {
        static var pathPromotion: String { return baseURL / version / "promotions" }
    }

    struct Search {
        static var pathSearch: String { return baseURL / version / "searchs" }
    }

    struct Favorite {
        static var pathFavorite: String { return Api.Path.User.pathUser / "favorites" }
    }
}

// MARK: - Path User
extension Api.Path.User {
    struct Login: ApiPath {
        static var path: String { return pathUser / "login" }

        var urlString: String {
            return Login.path
        }
    }

    struct Register: ApiPath {
        static var path: String { return pathUser / "register" }

        var urlString: String {
            return Register.path
        }
    }

    struct Me: ApiPath {
        static var path: String { return pathUser / "me" }

        var urlString: String {
            return Me.path
        }
    }

    struct Update: ApiPath {
        static var path: String { return pathUser / "update" }

        var urlString: String {
            return Update.path
        }
    }

    struct Avatar: ApiPath {
        static var path: String { return pathUser / "avatar" }

        var urlString: String {
            return Update.path
        }
    }
}

// MARK: - Path Promotions
extension Api.Path.Promotion {
    struct ListPromotion: ApiPath {
        static var path: String { return pathPromotion }

        var urlString: String {
            return ListPromotion.path
        }
    }

    struct DetailPromotion: ApiPath {
        static var path: String { return pathPromotion }

        let id: Int
        var urlString: String {
            return DetailPromotion.path / id
        }
    }
}

// MARK: - Path Search
extension Api.Path.Search {
    struct Promotion: ApiPath {
        static var path: String { return pathSearch }

        var urlString: String {
            return Promotion.path
        }
    }
}

// MARK: - Path Favorites
extension Api.Path.Favorite {
    struct ListFavorite: ApiPath {
        static var path: String { return pathFavorite }

        var urlString: String {
            return ListFavorite.path
        }
    }

    struct DeleteOneFavorite: ApiPath {
        static var path: String { return pathFavorite }

        let id: Int
        var urlString: String {
            return DeleteOneFavorite.path / id
        }
    }
}

// MARK: - Core Template
protocol URLStringConvertible {
    var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
    static var path: String { get }
}

extension URL: URLStringConvertible {
    var urlString: String { return absoluteString }
}

extension Int: URLStringConvertible {
    var urlString: String { return String(describing: self) }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

extension CustomStringConvertible where Self: URLStringConvertible {
    var urlString: String { return description }
}
