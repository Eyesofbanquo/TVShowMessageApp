//
//  ShowResultsViewController.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

protocol ResultsViewControllerDelegate : class {
    func sendTVInformation()
    
}

class ShowResultsViewController: UIViewController {

    @IBOutlet weak var showSummary: UITextView!
    @IBOutlet weak var _posterImageView: UIImageView!
    @IBOutlet weak var _visualEffectsImageView: UIImageView!
    
    @IBOutlet weak var showSummaryHTML: UIWebView!
    var selectedTVShow:TVShow!
    weak var delegate:ShowControllerDelegate!
    
    @IBOutlet weak var _sendShowButton: UIButton!
    var summaryText:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isToolbarHidden = false
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: URL(string: self.selectedTVShow.poster_url)!)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self._posterImageView.image = image
                    self._posterImageView.layer.masksToBounds = true
                    self._posterImageView.layer.cornerRadius = 20.0
                    self._visualEffectsImageView.image = image
                }
            } catch {
                
            }
        }
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self._visualEffectsImageView.bounds
        self._visualEffectsImageView.addSubview(blurredEffectView)
        
        
        //self._showSummary.text = self.selectedTVShow.description!
        self.showSummaryHTML.loadHTMLString(self.selectedTVShow.description!, baseURL: nil)
        self.showSummaryHTML.backgroundColor = UIColor.clear
        //let string = showSummaryHTML.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
        let htmlString = self.selectedTVShow.description!
        do {
            var string = try NSAttributedString(data: htmlString.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.summaryText = string.string
            //self.showSummary.text = string.string
        } catch {
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTVMessage(_ sender: AnyObject) {
        delegate.sendTVInformation(show: self.selectedTVShow, posterImage: self._posterImageView.image)
    }

    @IBAction func buttonUnwind(_ sender: AnyObject) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            //self.delegate.dismiss()
            self.delegate.toCompactPresentationStyle()
        }
       //
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "to_ResultsContainerTableViewController" {
            let destination = segue.destination as! ShowResultsTableViewController
            destination.selectedShow = self.selectedTVShow
            
            destination.showSummaryText = self.summaryText
        }
    }
 

}
