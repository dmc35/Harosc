//
//  ConvertHelper.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/7/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class ConvertHelper {
    private static let arrSign: [Character] =
        ["á", "à", "ả", "ã", "ạ",
         "ă", "ắ", "ằ", "ẳ", "ẵ", "ặ",
         "â", "ấ", "ầ", "ẩ", "ẫ", "ậ",
         "đ",
         "é", "è", "ẻ", "ẽ", "ẹ",
         "ê", "ế", "ề", "ể", "ễ", "ệ",
         "í", "ì", "ỉ", "ĩ", "ị",
         "ó", "ò", "ỏ", "õ", "ọ",
         "ô", "ố", "ồ", "ổ", "ỗ", "ộ",
         "ơ", "ớ", "ờ", "ở", "ỡ", "ợ",
         "ú", "ù", "ủ", "ũ", "ụ",
         "ư", "ứ", "ừ", "ử", "ữ", "ự",
         "ý", "ỳ", "ỷ", "ỹ", "ỵ",

         "Á", "À", "Ả", "Ã", "Ạ",
         "Ă", "Ắ", "Ằ", "Ẳ", "Ẵ", "Ặ",
         "Â", "Ấ", "Ầ", "Ẩ", "Ẫ", "Ậ",
         "Đ",
         "É", "È", "Ẻ", "Ẽ", "Ẹ",
         "Ê", "Ế", "Ề", "Ể", "Ễ", "Ệ",
         "Í", "Ì", "Ỉ", "Ĩ", "Ị",
         "Ó", "Ò", "Ỏ", "Õ", "Ọ",
         "Ô", "Ố", "Ồ", "Ổ", "Ỗ", "Ộ",
         "Ơ", "Ớ", "Ờ", "Ở", "Ỡ", "Ợ",
         "Ú", "Ù", "Ủ", "Ũ", "Ụ",
         "Ư", "Ứ", "Ừ", "Ử", "Ữ", "Ự",
         "Ý", "Ỳ", "Ỷ", "Ỹ", "Ỵ"]

    private static let arrNoSign: [Character] =
        ["a", "a", "a", "a", "a",
         "a", "a", "a", "a", "a", "a",
         "a", "a", "a", "a", "a", "a",
         "d",
         "e", "e", "e", "e", "e",
         "e", "e", "e", "e", "e", "e",
         "i", "i", "i", "i", "i",
         "o", "o", "o", "o", "o",
         "o", "o", "o", "o", "o", "o",
         "o", "o", "o", "o", "o", "o",
         "u", "u", "u", "u", "u",
         "u", "u", "u", "u", "u", "u",
         "y", "y", "y", "y", "y",

         "a", "a", "a", "a", "a",
         "a", "a", "a", "a", "a", "a",
         "a", "a", "a", "a", "a", "a",
         "d",
         "e", "e", "e", "e", "e",
         "e", "e", "e", "e", "e", "e",
         "i", "i", "i", "i", "i",
         "o", "o", "o", "o", "o",
         "o", "o", "o", "o", "o", "o",
         "o", "o", "o", "o", "o", "o",
         "u", "u", "u", "u", "u",
         "u", "u", "u", "u", "u", "u",
         "y", "y", "y", "y", "y"
    ]

    class func convertVN(text: String) -> String {
        var arr = Array(text)
        for i in 0..<arr.count {
            for j in 0..<arrSign.count where arr[i] == arrSign[j] {
                arr[i] = arrNoSign[j]
                break
            }
        }
        return String(arr)
    }
}
