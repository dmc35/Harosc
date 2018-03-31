//
//  UIImageViewExt.swift
//  MyApp
//
//  Created by Cuong Doan M. on 2/26/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func imageFromUrl(urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async { [weak self] in
                guard let this = self, let data = data else { return }
                this.image = UIImage(data: data)
            }
        }
        task.resume()
    }

    func setImage(with urlString: String, placeholder: UIImage = #imageLiteral(resourceName: "im_image")) {
        guard let url = URL(string: urlString) else {
            image = placeholder
            return
        }
        kf.setImage(with: url, placeholder: placeholder)
    }
}
