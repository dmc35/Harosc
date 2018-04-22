//
//  File.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/19/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM
import RealmSwift

final class ProfileViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum FavoriteResult {
        case success
        case failure(String)
    }

    enum AlertRemove {
        case all
        case one

        var title: String {
            return "Xoá mục yêu thích"
        }

        var msg: String {
            switch self {
            case .all:
                return "Xoá tất cả mục yêu thích?"
            case .one:
                return "Xoá mục yêu thích này?"
            }
        }
    }

    var title = App.String.kProfile
    var listFavorites: [Datas] = []
    var id = 0

    weak var delegate: ViewModelDelegate?

    // MARK: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return listFavorites.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> ViewModel {
        let itemFavorite = listFavorites[indexPath.row]
        return ProfileCollectionCellViewModel(itemFavorite)
    }

    // MARK: - processProfile
    func getListFavorite(_ completion: @escaping (FavoriteResult) -> Void) {
        Api.Favorite.listFavorite { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                if let value = value as? Promotion {
                    this.listFavorites = Array(value.datas)
                    completion(.success)
                    return
                }
                completion(.failure(App.String.kLoadError))
            case .failure:
                completion(.failure(App.String.kLoadError))
            }
        }
    }

    func deleteListFavorite(_ completion: @escaping (FavoriteResult) -> Void) {
        Api.Favorite.deleteListFavorite { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.listFavorites.removeAll()
                completion(.success)
            case .failure:
                completion(.failure(App.String.kDeleteError))
            }
        }
    }

    func deleteOneFavorite(_ completion: @escaping (FavoriteResult) -> Void) {
        let params = Api.Favorite.FavoriteParams(id: id)
        Api.Favorite.deleteOneFavorite(params: params) { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success:
                for (key, value) in this.listFavorites.enumerated() where value.id == this.id {
                    this.listFavorites.remove(at: key)
                }
                completion(.success)
            case .failure:
                completion(.failure(App.String.kDeleteError))
            }
        }
    }
}
