//
//  NewsCell.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NewsCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var country: UILabel!
    
    
//TODO: bookmark button
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    
 
    
    func setupCell(){
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.cornerRadius = 4.0
        self.contentView.layer.borderWidth = 1.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        newsImage.layer.cornerRadius = 10.0
        newsImage.kf.indicator?.startAnimatingView()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    }
    
}

extension UIView {

func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
    }
}
