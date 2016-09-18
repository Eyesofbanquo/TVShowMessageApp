//
//  SearchingViewModel.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation

class SearchingViewModel : ViewModelProtocol {
    public private(set) var data:[TVShow]?
    unowned var delegate:SearchingViewController
    
    init(delegate:SearchingViewController){
        self.data = [TVShow]()
        self.delegate = delegate

    }
    
    func clearSearchData(){
        self.data = []
    }
    
    func addShow(show: TVShow) {
        self.data!.append(show)
        self.delegate._tableView.reloadData()
    }
}
