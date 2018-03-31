//
//  MapViewModel.swift
//  Tutorial
//
//  Created by Cuong Doan M. on 1/19/18.
//  Copyright © 2018 Cuong Doan M. All rights reserved.
//

import MVVM
import MapKit
import RealmSwift

final class MapViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum MapResult {
        case success
        case failure
    }

    var annotations: [PinAnnotation] = []
    let title = App.String.kMap
    var radius: Float = 1_000
    var datas: [Datas] = []
    var limit = 200
    var currentPage = 0
    var center: CLLocationCoordinate2D?

    weak var delegate: ViewModelDelegate?

    // MARK: - Public
    func getAnnotation() {
        annotations = []
        for i in 0..<datas.count {
            let data = datas[i]
            let annotation = PinAnnotation(title: data.title, subtitle: data.address,
                                           latitude: data.lat, longitude: data.long, id: data.id
            )
            let locationShow = CLLocation(latitude: annotation.latitude, longitude: annotation.longitude)
            if let center = center {
                let locationCenter = CLLocation(latitude: center.latitude, longitude: center.longitude)
                if locationCenter.distance(from: locationShow) < CLLocationDistance(radius) {
                    annotations.append(annotation)
                }
            }
        }
    }

    // MARK: - processMap
    func getListPromotion(completion: @escaping (MapResult) -> Void) {
        let params = Api.Promotion.PromotionParams(limit: limit, page: currentPage)
        Api.Promotion.listPromotion(params: params) { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                if let value = value as? Promotion {
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
