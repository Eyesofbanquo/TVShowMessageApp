//
//  MainViewController.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func sendTVInformation(show:TVShow, posterImage:UIImage?)
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var _collectionView: UICollectionView!
    
    @IBOutlet weak var _searchBar: UISearchBar!
    static let storyboardID = "MainController"
    
    var items:[String] = ["1", "2", "3", "4"]
    var model:MainViewModel!
    weak var delegate:MainViewControllerDelegate?
    var cache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._collectionView.delegate = self
        
        //create cache for storing images that can be passed into other viewcontrollers
        self.cache = NSCache()
        
        self.model = MainViewModel()
        //self.model.delegate = self
        
        let api = ShowAPI(url: "http://api.tvmaze.com/shows?q=girls", delegate: self.model)
        api.request()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = self.model.data![indexPath.row]
        let image = self.cache.object(forKey: indexPath.row as AnyObject) as? UIImage
        self.delegate?.sendTVInformation(show: show, posterImage: image)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.model.data?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCollectionViewCell
        cell._posterTitle.text = self.model.data![indexPath.row].name
        
        //See if there are any images loaded into the cache. If not, create the images then load them into the cache
        if self.cache.object(forKey: indexPath.row as AnyObject) != nil {
            cell._posterImageView.image = self.cache.object(forKey: indexPath.row as AnyObject) as? UIImage
        } else {
            DispatchQueue.global().async{
                [unowned self] in
                do {
                    let data = try Data(contentsOf: URL(string: self.model.data![indexPath.row].poster_url)!)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.cache.setObject(image!, forKey: indexPath.row as AnyObject)
                        cell._posterImageView.image = image
                        
                        //self._collectionView.reloadItems(at: [indexPath])
                    }
                    
                } catch {
                    fatalError()
                }
            }
        }
        
        return cell
    }

}
