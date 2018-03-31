//
//  HomeViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/18/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM
import RealmSwift

final class HomeViewModel: MVVM.ViewModel {

    // MARK: - Properties
    private struct Config {
        static let heightCell: CGFloat = 237.5
    }

    enum HomeResult {
        case success
        case failure
    }

    var isLoading = false
    let title = App.String.kHome
    var datas: [Datas] = []
    var limit = 20
    var currentPage = 0
    var totalPage = 0

    weak var delegate: ViewModelDelegate?

    // MAR: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return datas.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> ViewModel {
        let data = datas[indexPath.row]
        return HomeCollectionCellViewModel(data: data)
    }

    func sizeForItemAt(_ collectionView: UICollectionView) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: Config.heightCell)
    }

    // MARK: - processHome
    func getListPromotion(completion: @escaping (HomeResult) -> Void) {
        let params = Api.Promotion.PromotionParams(limit: limit, page: currentPage)
        Api.Promotion.listPromotion(params: params) { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                if let value = value as? Promotion {
                    this.totalPage = value.totalPage
                    this.datas = Array(value.datas)
                    completion(.success)
                    return
                }
                completion(.failure)
            case .failure:
                completion(.failure)
            }
        }
    }

    func loadMoreData(completion: @escaping (HomeResult) -> Void) {
        currentPage += 1
        if currentPage > totalPage {
            completion(.failure)
            return
        } else {
            let params = Api.Promotion.PromotionParams(limit: limit, page: currentPage)
            Api.Promotion.listPromotion(params: params) { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    if let value = value as? Promotion {
                        guard !value.datas.isEmpty else {
                            completion(.failure)
                            return
                        }
                        this.datas.append(contentsOf: Array(value.datas))
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

    func refreshData(completion: @escaping (HomeResult) -> Void) {
        currentPage = 0
        let params = Api.Promotion.PromotionParams(limit: limit, page: currentPage)
        Api.Promotion.listPromotion(params: params) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                if let value = value as? Promotion {
                    this.datas.removeAll()
                    this.datas = Array(value.datas)
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
