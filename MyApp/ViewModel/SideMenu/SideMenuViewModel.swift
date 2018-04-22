//
//  SideMenuViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/23/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import MVVM
import RealmSwift

var user = User()

final class SideMenuViewModel: MVVM.ViewModel {

    // MARK: - Properties
    enum SideMenuResult {
        case success
        case failure(String)
    }

    enum Menu {
        case home
        case map
        case profile

        var title: String {
            switch self {
            case .home:
                return App.String.kHome
            case .map:
                return App.String.kMap
            case .profile:
                return App.String.kProfile
            }
        }
    }

    let menus: [Menu] = [.home, .map, .profile]
    var token: NotificationToken?

    weak var delegate: ViewModelDelegate?

    // MARK: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return menus.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> ViewModel {
        let menu = menus[indexPath.row]
        return SideMenuCellViewModel(title: menu.title)
    }

    func logOut() {
        api.session.accessToken = nil
        AppDelegate.shared.changeRootView(vc: .login)
        User.queryDeleteUser()
    }

    // MARK: - processSideMenu
    func getProfileUser(completion: @escaping (SideMenuResult) -> Void) {
        Api.User.getProfileUser { (result) in
            switch result {
            case .success:
                completion(.success)
            case .failure:
                completion(.failure(App.String.kLoadError))
            }
        }
    }

    func fetchData() {
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            token = users.observe({ [weak self](change) in
                guard let this = self else { return }
                if let userFirst = users.first {
                    user = userFirst
                    this.notify(change: change)
                }
            })
        } catch {
            print(error)
        }
    }
}
