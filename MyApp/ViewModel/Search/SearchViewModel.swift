//
//  SearchViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/6/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import MVVM
import Alamofire

final class SearchViewModel: MVVM.ViewModel {

    // MAR: - Properties
    private struct Config {
        static let heightCell: CGFloat = 237.5
    }

    enum SearchResult: Int {
        case success
        case empty
    }

    var keyword = ""
    var limit = 10
    var currentPage = 0
    var totalPage = 0
    var datas: [Datas] = []
    var request: Request?

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

    // MARK: - processSearch
    func searchData(completion: @escaping (SearchResult) -> Void) {
        datas.removeAll()
        request?.cancel()
        if keyword.isEmpty {
            completion(.empty)
        } else {
            let params = Api.Search.SearchParams(keyword: keyword, limit: limit, page: currentPage)
            request = Api.Search.listPromotion(params: params) { [weak self] (result) in
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    if let value = value as? Promotion {
                        guard !value.datas.isEmpty else {
                            completion(.empty)
                            return
                        }
                        this.totalPage = value.totalPage
                        this.datas = Array(value.datas)
                        completion(.success)
                        return
                    }
                    completion(.empty)
                case .failure:
                    completion(.empty)
                }
            }
        }
    }

    func loadMoreData(completion: @escaping (SearchResult) -> Void) {
        currentPage += 1
        if currentPage > totalPage {
            completion(.empty)
            return
        }
        if keyword.isEmpty {
            completion(.empty)
        } else {
            let params = Api.Search.SearchParams(keyword: keyword, limit: limit, page: currentPage)
            Api.Search.listPromotion(params: params) { [weak self] (result) in
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    if let value = value as? Promotion {
                        guard !value.datas.isEmpty else {
                            completion(.empty)
                            return
                        }
                        this.datas.append(contentsOf: Array(value.datas))
                        completion(.success)
                        return
                    }
                    completion(.empty)
                case .failure:
                    completion(.empty)
                }
            }
        }
    }
}
