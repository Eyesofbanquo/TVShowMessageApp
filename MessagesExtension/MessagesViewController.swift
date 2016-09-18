//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Markim Shaw on 9/16/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    var tappedOnMessage:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.dismiss()
        self.tappedOnMessage = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        super.willBecomeActive(with: conversation)
        self.presentViewController(for: conversation, with: self.presentationStyle)
        // Remove any existing child controllers.
        
        //self.present(controller, animated: true, completion: nil)
        // Use this method to configure the extension and restore previously stored state.
    }
    
    func instantiateShowCollectionController() -> ShowCollectionViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ShowCollectionViewController.storyboardID) as? ShowCollectionViewController else { fatalError("Unable to instantiate an ShowCollectionController from the storyboard") }
        controller.delegate = self
        return controller
    }
    
    func instantiateSearchNavigationController() -> UINavigationController {
        guard let nav = storyboard?.instantiateViewController(withIdentifier: "SearchNavigation") as? UINavigationController else { fatalError() }
        let controller = nav.topViewController as! SearchingViewController
        controller.messagesViewController = self
        return nav
    }
    
    func instantiateShowResultsViewController() -> ShowResultsViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ResultsController") as? ShowResultsViewController else { fatalError("Unable to instantiate an ShowCollectionController from the storyboard") }
        //controller.delegate = self
        return controller
    }
    
    fileprivate func presentViewController(for conversation:MSConversation, with presentationStyle: MSMessagesAppPresentationStyle){
        let controller:UIViewController
        
        if presentationStyle == .compact {
            controller = self.instantiateShowCollectionController()
        } else if presentationStyle == .expanded && self.tappedOnMessage == true {
            controller = self.instantiateSearchNavigationController()
        } else {
            
            if let message = conversation.selectedMessage{
                self.tappedOnMessage = false
                let messageURL = message.url
                let components = URLComponents(url: messageURL!, resolvingAgainstBaseURL: false)
                var name:String = ""
                var poster_url:String = ""
                var description:String = ""
                
                for (_, item) in (components?.queryItems?.enumerated())! {
                    switch item.name {
                    case "name":
                        name = item.value!
                        break
                    case "poster_url":
                        poster_url = item.value!
                        break
                    case "description":
                        description = item.value!
                        break
                    default:
                        break
                    }
                }
                
                let show = TVShow(name: name, poster_url: poster_url, description: description)
                controller = self.instantiateShowResultsViewController()
                (controller as! ShowResultsViewController).selectedTVShow = show
                (controller as! ShowResultsViewController).delegate = self
            } else {
                controller = self.instantiateSearchNavigationController()
            }
        }
        /*if presentationStyle == .compact && self.tappedOnMessage == true {
            
        }*/
        
        
        /*if presentationStyle == .compact {
            controller = self.instantiateShowCollectionController()
            
        } else if self.tappedOnMessage == true{
            //if self.tappedOnMessage == true{
                if let message = conversation.selectedMessage{
                    let messageURL = message.url
                    let components = URLComponents(url: messageURL!, resolvingAgainstBaseURL: false)
                    var name:String = ""
                    var poster_url:String = ""
                    var description:String = ""
                    
                    for (_, item) in (components?.queryItems?.enumerated())! {
                        switch item.name {
                        case "name":
                            name = item.value!
                            break
                        case "poster_url":
                            poster_url = item.value!
                            break
                        case "description":
                            description = item.value!
                            break
                        default:
                            break
                        }
                    }
                    
                    let show = TVShow(name: name, poster_url: poster_url, description: description)
                    controller = self.instantiateShowResultsViewController()
                    (controller as! ShowResultsViewController).selectedTVShow = show
                    (controller as! ShowResultsViewController).delegate = self

                //}
            } else {
                controller = self.instantiateSearchNavigationController()
            }
        }
        
        /*if self.tappedOnMessage == true {

            //controller = self.instantiateShowCollectionController()
                            //conversation.selectedMessage?.url = nil
                //(controller as! ShowResultsViewController)._sendShowButton.isHidden = true
                
            }
        } else {
        }*/*/
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
       
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.bounds = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        
        //self.presentViewController(for: conversation, with: self.presentationStyle)
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.

        //self.dismiss(animated: false, completion: nil)

        
        // Use this method to prepare for the change in presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        if self.presentationStyle == .compact {
            print("compact")
        } else {
            print("expanded")
        }
        self.presentViewController(for: conversation, with: presentationStyle)

        //self.dismiss(animated: true, completion: nil)


    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        //guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        //self.presentViewController(for: conversation, with: self.presentationStyle)
        // Use this method to finalize any behaviors associated with the change in presentation style.
        //guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        //self.presentViewController(for: conversation, with: presentationStyle)
        if self.presentationStyle == presentationStyle {
            //print("already transitioned")
        }
    }

}

extension MessagesViewController : ResultsViewControllerDelegate {
    func sendTVInformation() {
        
    }
}

extension MessagesViewController: ShowControllerDelegate {
    
    func toCompactPresentationStyle() {
        tappedOnMessage = self.backFromController
        self.requestPresentationStyle(MSMessagesAppPresentationStyle.compact)
    }
    
    func toExtendedPresentationStyle() {
        self.requestPresentationStyle(MSMessagesAppPresentationStyle.expanded)
    }

    func sendTVInformation(show:TVShow, posterImage:UIImage?) {
        
        var q = URLComponents()
        let nameQItem = URLQueryItem(name: "name", value: show.name)
        let posterURLQItem = URLQueryItem(name: "poster_url", value: show.poster_url)
        //need to validate this one
        let descriptionQItem = URLQueryItem(name: "description", value: show.description!)
        q.queryItems = [nameQItem, posterURLQItem, descriptionQItem]
        
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        layout.caption = show.name
        
        //Create the message image
        /*UIGraphicsBeginImageContextWithOptions(posterImage!.bounds.size,
                                               posterImage!.isOpaque, 0)
        posterImage!.drawHierarchy(in: posterImage!.bounds,
                                    afterScreenUpdates: true)
        
        layout.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()*/
        layout.image = posterImage
        
        message.layout = layout
        message.url = q.url
        message.shouldExpire = true
        
        
        let conversation = self.activeConversation
        conversation?.insert(message, completionHandler: {
            error in
            if let e = error {
                print(e)
            }
        })
        
        self.dismiss()
    }
}
