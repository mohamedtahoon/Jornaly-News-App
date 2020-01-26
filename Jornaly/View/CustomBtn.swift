//
//  CustomBtn.swift
//  Jornaly
//
//  Created by MacBookPro on 1/25/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 4.5
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.borderWidth = 0.8
    }

}

