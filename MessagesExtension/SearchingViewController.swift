//
//  SearchingViewController.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Messages

class SearchingViewController: UIViewController {
    @IBOutlet weak var _tableView: UITableView!

    @IBOutlet weak var _dimView: UIView!
    @IBOutlet weak var _searchBar: UISearchBar!
    
    var model:SearchingViewModel!
    weak var messagesViewController:MSMessagesAppViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = SearchingViewModel(delegate: self)
        self.navigationController?.isNavigationBarHidden = true
        self._tableView.keyboardDismissMode = .onDrag
        //self._dimView.layer.opacity = 0.6
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "to_ShowResultsViewController" {
            print(sender)
            if let cell = sender as? SearchingTableViewCell {
                let indexPath = self._tableView.indexPath(for: cell)
                if let data = self.model.data {
                    let destination = segue.destination as! ShowResultsViewController
                    destination.delegate = messagesViewController as! ShowControllerDelegate
                    destination.selectedTVShow = data[indexPath!.row]
                }
                
            }
        }
            
    }
    
}

extension SearchingViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.model.clearSearchData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self._dimView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self._dimView.isHidden = false
        self.model.clearSearchData()
        let api_call = ShowAPI(url: "http://api.tvmaze.com/search/shows?", params: ["q":searchText], delegate: model)
        api_call.request()
    }
}

extension SearchingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.model.data?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsCell", for: indexPath) as! SearchingTableViewCell
        
        guard let modelData = self.model.data , modelData.count != 0 else { return cell }
        cell.showTitle.text = modelData[indexPath.row].name
        
        return cell
    }
}
