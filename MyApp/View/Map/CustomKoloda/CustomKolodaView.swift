//
//  CustomKolodaView.swift
//  MyApp
//
//  Created by Cuong Doan M. on 4/5/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Koloda

class CustomKolodaView: KolodaView {

    // MARK: - Life Cycle
    override func frameForCard(at index: Int) -> CGRect {
        var frame = super.frameForCard(at: index)
        if index != 0 {
            frame.origin.y -= 30
            frame.size.width -= 12
        }
        return frame
    }
}
