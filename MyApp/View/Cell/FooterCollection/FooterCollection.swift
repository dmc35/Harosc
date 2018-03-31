//
//  FooterCollection.swift
//  MyApp
//
//  Created by Cuong Doan M. on 3/9/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class FooterCollection: UICollectionViewCell {

    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    var isAnimatingFinal: Bool = false
    var currentTransform: CGAffineTransform?

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareInitialAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setTransform(inTransform: CGAffineTransform, scaleFactor: CGFloat) {
        if isAnimatingFinal {
            return
        }
        currentTransform = inTransform
        loadMoreIndicator?.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
    }

    func prepareInitialAnimation() {
        isAnimatingFinal = false
        loadMoreIndicator?.stopAnimating()
        loadMoreIndicator?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }

    func startAnimate() {
        isAnimatingFinal = true
        loadMoreIndicator?.startAnimating()
    }

    func stopAnimate() {
        isAnimatingFinal = false
        loadMoreIndicator?.stopAnimating()
    }

    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.loadMoreIndicator?.transform = CGAffineTransform.identity
        }
    }
}
