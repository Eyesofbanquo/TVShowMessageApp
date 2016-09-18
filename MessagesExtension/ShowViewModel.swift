//
//  MainViewModel.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import Alamofire



class ShowViewModel : ViewModelProtocol {
    weak var delegate:ShowCollectionViewController?
    public private(set) var data:[TVShow]?
    
    init(delegate:ShowCollectionViewController){
        data = [TVShow]()
        self.delegate = delegate
    }
    
    func addShow(show:TVShow){
        self.data!.append(show)
        self.delegate?.collectionView?.reloadData()
    }
}
