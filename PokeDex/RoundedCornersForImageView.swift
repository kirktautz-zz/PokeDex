//
//  RoundedCornersForImageView.swift
//  PokeDex
//
//  Created by Kirk Tautz on 5/23/16.
//  Copyright © 2016 Kirk Tautz. All rights reserved.
//

import UIKit

class RoundedCornersForImageView: UIImageView {
 
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
}
