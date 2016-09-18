//
//  ShowCollectionViewController.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PosterCell"

protocol ShowControllerDelegate: class {
    func sendTVInformation(show:TVShow, posterImage:UIImage?)
}

class ShowCollectionViewController: UICollectionViewController {
    
    static let storyboardID = "ShowController"
    
    var items:[String] = ["1", "2", "3", "4"]
    var model:ShowViewModel!
    weak var delegate:ShowControllerDelegate?
    var cache:NSCache<AnyObject, AnyObject>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //create cache for storing images that can be passed into other viewcontrollers
        self.cache = NSCache()
        
        self.model = ShowViewModel(delegate: self)
        //self.model.delegate = self
        
        let api = ShowAPI(url: "http://api.tvmaze.com/shows", params: [:], delegate: self.model)
        api.request()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view:UICollectionReusableView? = nil
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShowHeaderCell", for: indexPath) as! ShowCollectionReusableView
            view = header
        }
        
        return view!
    }
 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = self.model.data![indexPath.row]
        let image = self.cache.object(forKey: "\(self.model.data![indexPath.row].name)" as AnyObject) as? UIImage
        self.delegate?.sendTVInformation(show: show, posterImage: image)
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let count = self.model.data?.count else { return 0 }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCollectionViewCell
        cell._posterTitle.text = self.model.data![indexPath.row].name
        
        //See if there are any images loaded into the cache. If not, create the images then load them into the cache
        if self.cache.object(forKey: indexPath.row as AnyObject) != nil {
            cell._posterImageView.image = self.cache.object(forKey: "\(self.model.data![indexPath.row].name)" as AnyObject) as? UIImage
        } else {
            DispatchQueue.global().async{
                [weak self] in
                do {
                    let data = try Data(contentsOf: URL(string: (self?.model.data![indexPath.row].poster_url)!)!)
                    let image = UIImage(data: data)
                    let index = indexPath.row
                    self?.cache.setObject(image!, forKey: "\(self?.model.data![index].name)" as AnyObject)
                    DispatchQueue.main.sync {
                        guard let i = image else { return }
                        cell._posterImageView.image = i
                    }
                    
                } catch {
                    fatalError()
                }
            }
        }
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
