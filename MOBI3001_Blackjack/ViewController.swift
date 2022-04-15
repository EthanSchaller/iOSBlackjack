//
//  ViewController.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-13.
//

import UIKit
import CoreData

class ViewController: UITabBarController {
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let crntPlayer = UserPlayer(context: appContext)
        
        crntPlayer.name = "Player"
        crntPlayer.points = 0
        
        try! appContext.save()
    }
}

