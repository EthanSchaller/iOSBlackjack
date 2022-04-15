//
//  HomeController.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-14.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    @IBOutlet weak var nmInput: UITextField!
    @IBOutlet weak var txtCrntNm: UILabel!
    @IBOutlet weak var bttnEnter: UIButton!
    
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adds a player into Core Data with default values and saving it
        let crntPlayer = UserPlayer(context: appContext)
        
        crntPlayer.name = "Player"
        crntPlayer.points = 0
        
        try! appContext.save()
    }
    
    @IBAction func SaveEnteredName(_ sender: Any) {
        //setting inputted name into Core Data allowing for it to be used on the game tab
        let players =  try! appContext.fetch(UserPlayer.fetchRequest())
        
        for player in players {
            if(nmInput.text != "") {
                (player as! UserPlayer).name = nmInput.text
                
                try! appContext.save()
            }
            
            txtCrntNm.text = "Current Name: \(((player as! UserPlayer).name)!)"
        }
    }
    
}
