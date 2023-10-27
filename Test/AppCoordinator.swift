//
//  AppCoordinator.swift
//  Test
//
//  Created by Kseniya Zharikova on 25/10/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController : UINavigationController { get set }
    func openMessages()
}

class AppCoordinator : Coordinator {
    var navigationController: UINavigationController
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openMessages() {
        let vc = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        navigationController.pushViewController(vc, animated: true)
    }
}
