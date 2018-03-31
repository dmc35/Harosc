//
//  Strings.swift
//  MyApp
//
//  Created by DaoNV on 5/23/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

/**
 This file defines all localizable strings which are used in this application.
 Please localize defined strings in `Resources/Localizable.strings`.
 */

import Foundation
import SwiftUtils

extension App {
    struct String {

        // System
        static let authorization = "Authorization"

        // AppDelegate
        static let kAppDelegateError = "Cant cast to AppDelegate"
        static let kAlertRequestTitle = "Request location service"
        static let kAlertRequestMessage = "Please go to Setting > Privacy > Location service to turn on location service for \"Map Demo\""

        // Navigation Title
        static let SignIn = "Sign in"
        static let SignUp = "Sign up"
        static let Home = "Home"
        static let Map = "Map"
        static let Profile = "Profile"
        static let EditProfile = "Edit Profile"

        // Login Screen
        static let success = "Success"
        static let signInError = "Sign In Error"
        static let signInNofti = "Sign in Error, Try again please!"
        static let emptyEmail = "Email Empty"
        static let emptyPass = "Password Empty"
        static let validEmail = "Validate Email"

        // Register Screen
        static let emptyUsername = "Username Empty"
        static let signUpError = "Sign Up Error"
        static let signUpNofti = "Sign up Error, Try again please!"
        static let wrongPass = "Wrong Password"

        // Cell
        static let ErrorCell = "Error-Cell"
        static let HomeCollectionCell = "HomeCollectionCell"
        static let SideMenuTableCell = "SideMenuTableCell"
        static let DetailCollectionCell = "DetailCollectionCell"
        static let DetailContentCell = "DetailContentCell"
        static let DetailMapCell = "DetailMapCell"
        static let ProfileCollectionCell = "ProfileCollectionCell"
        static let FooterCollection = "FooterCollection"

        // User
        static let name = "name"
        static let email = "email"
        static let password = "password"
        static let confirm = "confirm password"
        static let id = "id"
        static let token = "token"
        static let phone = "phone"
        static let birthday = "birthday"
        static let avatarUrl = "avatarUrl"
        static let gender = "gender"

        // Datas
        static let currentPage = "current_page"
        static let totalPage = "total_page"
        static let datas = "datas"

        // Promotion
        static let thumImage = "thum_image"
        static let long = "applying_branches.0.long"
        static let lat = "applying_branches.0.lat"
        static let address = "applying_branches.0.address"
        static let title = "title"
        static let code = "code"
        static let page = "page"
        static let limit = "limit"
        static let promotionId = "promotion_id"

        // Promotion Detail
        static let url = "url"
        static let images = "images"
        static let menuImages = "menu_images"
        static let content = "content"

        // Map
        static let PinAnnotation = "PinAnnotation"

        // Search
        static let keyword = "keyword"

        // Gender
        static let male = "Male"
        static let female = "Female"
        static let none = "None"

        // Other
        static let dateFormat = "dd-MM-yyyy"
        static let next = "Next"

        // View
        static let kHome = "Trang chủ"
        static let kMap = "Bản đồ"
        static let kProfile = "Thông tin tài khoản"
        static let kCompare = "So sánh giá"
        static let kLogin = "Đăng nhập"
        static let kDetail = "Chi tiết khuyến mãi"
        static let kEditProfile = "Cập nhật thông tin"
        static let kMale = "Nam"
        static let kFemale = "Nữ"
        static let kNone = "Chưa xác định"

        // Alert
        static let kError = "Lỗi"
        static let kOk = "Đồng ý"
        static let kRegisterError = "Đăng ký thất bại!"
        static let kLoginError = "Đăng nhập thất bại!"
        static let kNoftiEmail = "Kiểm tra hộp thư đến để lấy mã xác nhận!"
        static let kNofti = "Thông báo"
        static let kLoadError = "Tải dữ liệu thất bại!"
        static let kDeleteError = "Xoá dữ liệu thất bại!"
        static let kAddError = "Thêm dữ liệu thất bại!"
        static let kEmpty = "Thông tin chưa đầy đủ!"
        static let kPassword = "Nhập lại mật khẩu!"
        static let kEmailError = "Sai định dạng Email!"
        static let kUpdateError = "Cập nhật thông tin thất bại!"

        static let error = "ERROR".localized()
        static let ok = "OK".localized()
    }
}
