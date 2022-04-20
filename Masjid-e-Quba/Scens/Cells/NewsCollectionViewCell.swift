//
//  NewsCollectionViewCell.swift
//  Masjid-e-Quba
//
//  Created by Ali Waseem on 1/27/22.
//

import UIKit
import ScalingCarousel

class NewsCollectionViewCell: ScalingCarouselCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var shadowView:UIView!
}
