//
//  TVShow.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

struct TVShow {
    let name:String
    let poster_url:String
    var poster:UIImage?
    let description:String?
    
    init(name:String, poster_url:String, description:String){
        self.name = name
        self.poster_url = poster_url
        self.description = description
    }
    
}
