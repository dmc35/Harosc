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
import SKPhotoBrowser

final class DetailViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum DetailResult {
        case success
        case failure(String)
    }

    enum ViewType {
        case collection
        case table
    }

    enum SectionType {
        case other
        case comment
    }

    enum RowType {
        case content
        case image
        case map
    }

    enum ImageType {
        case launch
        case menu
    }

    var listFavorites: [Datas] = []
    var isFavorite = false
    var title = App.String.kDetail
    var contentTitle = ""
    var sections: [SectionType] = [.other, .comment]
    var rows: [RowType] = [.content, .image, .map]
    var images: [Thumbnail] = []
    var menuImages: [Thumbnail] = []
    var comments: [Comment] = []
    var content = ""
    var contentText = ""
    var isUpgrade = false
    var commentId = 0
    private var detailToken: NotificationToken?
    var detailPromotion = DetailPromotion()
    var id = 0

    weak var delegate: ViewModelDelegate?

    // MARK: - Public
    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfItems(inSection section: Int, viewType: ViewType) -> Int {
        switch viewType {
        case .collection:
            if images.count > 5 {
                return 5
            }
            return images.count
        case .table:
            let section = sections[section]
            switch section {
            case .other:
                return rows.count
            case .comment:
                return comments.count
            }
        }
    }

    func viewModelForItem(at indexPath: IndexPath, viewType: ViewType) -> ViewModel {
        switch viewType {
        case .collection:
            let imageUrl = images[indexPath.row].url
            return DetailCollectionCellViewModel(url: imageUrl)
        case .table:
            let section = sections[indexPath.section]
            switch section {
            case .other:
                let row = rows[indexPath.row]
                switch row {
                case .content:
                    return DetailContentCellViewModel(title: contentTitle, content: content)
                case .image:
                    var launchUrl = ""
                    var launchNumber = 0
                    var menuUrl = ""
                    var menuNumber = 0
                    if !images.isEmpty {
                        launchUrl = images[0].url
                        launchNumber = images.count
                    }
                    if !menuImages.isEmpty {
                        menuUrl = menuImages[0].url
                        menuNumber = menuImages.count
                    }
                    return DetailImageCellViewModel(launchUrl: launchUrl, launchNumber: launchNumber, menuUrl: menuUrl, menuNumber: menuNumber)
                case .map:
                    return DetailMapCellViewModel(detailPromotion: detailPromotion)
                }
            case .comment:
                let comment = comments[indexPath.row]
                return DetailCommentCellViewModel(comment: comment)
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

    func getPhotoBrowser(type: ImageType) -> [SKPhoto] {
        var photos: [SKPhoto] = []
        switch type {
        case .launch:
            images.forEach { (image) in
                let photo = SKPhoto.photoWithImageURL(image.url)
                photos.append(photo)
            }
        case .menu:
            menuImages.forEach { (image) in
                let photo = SKPhoto.photoWithImageURL(image.url)
                photos.append(photo)
            }
        }
        return photos
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
                completion(.failure(App.String.kLoadError))
            case .failure:
                completion(.failure(App.String.kLoadError))
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
                completion(.failure(App.String.kDeleteError))
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
                completion(.failure(App.String.kAddError))
            }
        }
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
                    this.menuImages = Array(value.menuImages)
                    this.comments = Array(value.comments)
                    this.contentTitle = value.title
                    this.content = value.content
                    completion(.success)
                    return
                }
                completion(.failure(App.String.kLoadError))
            case .failure:
                completion(.failure(App.String.kLoadError))
            }
        }
    }

    func sendComment(_ completion: @escaping (DetailResult) -> Void) {
        if isUpgrade {
            let params = Api.User.CommentParams(id: commentId, content: contentText)
            Api.User.fixComment(params: params, completion: { (result) in
                switch result {
                case .success:
                    completion(.success)
                case .failure:
                    completion(.failure(App.String.kSendCommentError))
                }
            })
        } else {
            if !contentText.isEmpty {
                let params = Api.User.CommentParams(id: id, content: contentText)
                Api.User.sendComment(params: params) { (result) in
                    switch result {
                    case .success:
                        completion(.success)
                    case .failure:
                        completion(.failure(App.String.kSendCommentError))
                    }
                }
            } else {
                completion(.failure(App.String.kCommentEmpty))
            }
        }
    }

    func deleteComment(commentId: Int, userId: Int, _ completion: @escaping (DetailResult) -> Void) {
        if user.id == userId {
            let params = Api.User.CommentParams(id: commentId, content: "")
            Api.User.deleteComment(params: params, completion: { (result) in
                switch result {
                case .success:
                    completion(.success)
                case .failure:
                    completion(.failure(App.String.kCommentFail))
                }
            })
        } else {
            completion(.failure(App.String.kCommentError))
        }
    }

    func checkComment(id: Int, userId: Int, completion: @escaping (DetailResult) -> Void) {
        if userId == user.id {
            for value in comments where id == value.id {
                contentText = value.content
                isUpgrade = true
                commentId = id
                completion(.success)
            }
        } else {
            completion(.failure(App.String.kCommentError))
        }
    }
}
