//
//  GameController.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-14.
//

import UIKit

class GameController: UIViewController {
    @IBOutlet weak var plyrTitle: UILabel!
    
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let players =  try! appContext.fetch(UserPlayer.fetchRequest())
        
        for player in players {
            plyrTitle.text = "\(((player as! UserPlayer).name)!)'s Hand"
        }
    }
}
