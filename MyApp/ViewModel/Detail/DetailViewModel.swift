//
//  DetailViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/18/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM
import RealmSwift
import SwiftUtils

final class DetailViewModel: MVVM.ViewModel {

    // MARK: - Properties
    private struct Config {
        static let mapWidth = UIScreen.main.bounds.width
    }

    enum DetailResult {
        case success
        case failure
    }

    enum ViewType {
        case collection
        case table
    }

    enum RowType {
        case content
        case map
    }

    var listFavorites: [Datas] = []
    var isFavorite = false
    var title = App.String.kDetail
    var rows: [RowType] = [.content, .map]
    var images: [Thumbnail] = []
    var content = ""
    private var detailToken: NotificationToken?
    var detailPromotion = DetailPromotion()
    var id = 0

    weak var delegate: ViewModelDelegate?

    // MARK: - Public
    func numberOfItems(inSection section: Int, viewType: ViewType) -> Int {
        switch viewType {
        case .collection:
            if images.count > 10 {
                return 10
            }
            return images.count
        case .table:
            return rows.count
        }
    }

    func viewModelForItem(at indexPath: IndexPath, viewType: ViewType) -> ViewModel {
        switch viewType {
        case .collection:
            let imageUrl = images[indexPath.row].url
            return DetailCollectionCellViewModel(url: imageUrl)
        case .table:
            let row = rows[indexPath.row]
            switch row {
            case .content:
                return DetailContentCellViewModel(title: title, content: content)
            case .map:
                return DetailMapCellViewModel(detailPromotion: detailPromotion)
            }
        }
    }

    func sizeForItemAt(_ collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        let rowType = rows[indexPath.row]
        switch rowType {
        case .map:
            return 2 * Config.mapWidth / 3
        default:
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - processDetail
    func getListFavorite(_ completion: @escaping (DetailResult) -> Void) {
        Api.Favorite.listFavorite { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                if let value = value as? Promotion {
                    this.listFavorites = Array(value.datas)
                    completion(.success)
                    return
                }
                completion(.failure)
            case .failure:
                completion(.failure)
            }
        }
    }

    func deleteOneFavorite(_ completion: @escaping (DetailResult) -> Void) {
        let params = Api.Favorite.FavoriteParams(id: id)
        Api.Favorite.deleteOneFavorite(params: params) { (result) in
            switch result {
            case .success:
                completion(.success)
            case .failure:
                completion(.failure)
            }
        }
    }

    func addOneFavorite(_ completion: @escaping (DetailResult) -> Void) {
        let params = Api.Favorite.FavoriteParams(id: id)
        Api.Favorite.addFavorite(params: params) { (result) in
            switch result {
            case .success:
                completion(.success)
            case .failure:
                completion(.failure)
            }
        }
    }

    func checkFavorite() {
        for value in listFavorites where id == value.id {
            isFavorite = true
            return
        }
        isFavorite = false
    }

    func getDataDetail(_ completion: @escaping (DetailResult) -> Void) {
        let params = Api.Promotion.DetailPromotionParams(id: id)
        Api.Promotion.detailPromotion(params: params) { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                if let value = value as? DetailPromotion {
                    this.detailPromotion = value
                    this.images = Array(value.images)
                    this.content = value.content
                    completion(.success)
                    return
                }
                completion(.failure)
            case .failure:
                completion(.failure)
            }
        }
    }
}
