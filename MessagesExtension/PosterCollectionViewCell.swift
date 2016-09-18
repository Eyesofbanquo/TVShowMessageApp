//
//  PosterCollectionViewCell.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

protocol PosterCellCollectionProtocol {
    
}

class PosterCollectionViewCell: UICollectionViewCell, PosterCellCollectionProtocol {
    static let reuseIdentifier = "PosterCell"
    
    
    @IBOutlet weak var _posterImageView: UIImageView!
    @IBOutlet weak var _posterTitle:UILabel!
}
