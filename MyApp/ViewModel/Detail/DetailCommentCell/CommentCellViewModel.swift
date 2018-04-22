//
//  CommentCellViewModel.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/16/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class DetailCommentCellViewModel: MVVM.ViewModel {
    var id = 0
    var userId = 0
    var name = ""
    var imageUrl = ""
    var content = ""
    var date = ""

    init(comment: Comment) {
        id = comment.id
        userId = comment.userId
        name = comment.userName
        content = comment.content
        date = comment.date
        imageUrl = comment.userAvatarUrl
    }

    func calculateTimeAgo(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateString = dateString as String? {
            if let date = dateFormatter.date(from: dateString) {
                let dateNow = Date()
                let currentCalendar: Calendar = Calendar.current
                let components: DateComponents = currentCalendar.dateComponents([.day], from: date, to: dateNow)
                if let day = components.day {
                    if day > 0 {
                        return "\(String(describing: day)) days ago"
                    }
                }
            }
        }
        return "Today"
    }
}
