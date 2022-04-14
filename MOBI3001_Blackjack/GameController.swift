//
//  GameController.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-14.
//

import UIKit

class GameController: UIViewController {
    @IBOutlet weak var hCard1: UIImageView!
    @IBOutlet weak var hCard2: UIImageView!
    @IBOutlet weak var hCard3: UIImageView!
    @IBOutlet weak var hCard4: UIImageView!
    @IBOutlet weak var hCard5: UIImageView!
    
    @IBOutlet weak var pCard1: UIImageView!
    @IBOutlet weak var pCard2: UIImageView!
    @IBOutlet weak var pCard3: UIImageView!
    @IBOutlet weak var pCard4: UIImageView!
    @IBOutlet weak var pCard5: UIImageView!
    
    @IBOutlet weak var houseTotal: UILabel!
    @IBOutlet weak var plyrTitle: UILabel!
    @IBOutlet weak var plyrTotal: UILabel!
    
    @IBOutlet weak var bttnHit: UIButton!
    @IBOutlet weak var bttnStnd: UIButton!
    @IBOutlet weak var bttnStrt: UIButton!
    
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    class card {
        var name: String
        var value: Int
        var pic: String
        
        init(name: String, value: Int, pic: String) {
            self.name = name
            self.value = value
            self.pic = pic
        }
    }
    
    var deck: [card] = [card](repeating: card(name: "", value: 0, pic: ""), count: 52)
    
    var hHand: [card] = [card](repeating: card(name: "", value: 0, pic: ""), count: 5)
    var hValue = 0
    
    var pHand: [card] = [card](repeating: card(name: "", value: 0, pic: ""), count: 5)
    var pValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var i1 = 1
        var i2 = 1
        var i3 = 0
        
        while i1 <= 13 {
            i2 = 1
            while i2 <= 4 {
                deck[i3] = setupCard(tempNum: i1, tempSuit: i2)
                i2 += 1
                i3 += 1
            }
            
            i1 += 1
        }
        
        deck.shuffle();
        
        addToHands()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let players =  try! appContext.fetch(UserPlayer.fetchRequest())
        
        for player in players {
            plyrTitle.text = "\(((player as! UserPlayer).name)!)'s Hand"
        }
    }
    
    @IBAction func pressedHit(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedStand(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedStart(_ sender: UIButton) {
        bttnStrt.isHidden = true
        bttnHit.isHidden = false
        bttnStnd.isHidden = false
        
        hCard1.isHidden = false
        hCard2.isHidden = false
        
        pCard1.isHidden = false
        pCard2.isHidden = false
    }
    
    
    
    func setupCard(tempNum: Int, tempSuit: Int)->card {
        var newCard: card
        
        var name = ""
        var suit = ""
        var value = 0
        var pic = ""
        
        switch tempNum {
        case 1:
            name = "A"
            value = 11
            break;
            
        case 2:
            name = "2"
            value = 2
            break;
            
        case 3:
            name = "3"
            value = 3
            break;
            
        case 4:
            name = "4"
            value = 4
            break;
            
        case 5:
            name = "5"
            value = 5
            break;
            
        case 6:
            name = "6"
            value = 6
            break;
            
        case 7:
            name = "7"
            value = 7
            break;
            
        case 8:
            name = "8"
            value = 8
            break;
            
        case 9:
            name = "9"
            value = 9
            break;
            
        case 10:
            name = "10"
            value = 10
            break;
            
        case 11:
            name = "J"
            value = 10
            break;
            
        case 12:
            name = "Q"
            value = 10
            break;
            
        case 13:
            name = "K"
            value = 10
            break;
        
        default:
            name = ""
            break;
        }
        
        suit = setupSuit(temp: tempSuit)
        
        pic = getPic(tempSuit: suit, tempName: name)
        
        name += " of \(suit)"
        
        newCard = card(name: name, value: value, pic: pic)
        
        return newCard
    }
    
    func setupSuit(temp: Int)->String {
        var suit = ""
        
        switch temp {
        case 1:
            suit = "Spades"
            break;
            
        case 2:
            suit = "Hearts"
            break;
            
        case 3:
            suit = "Clubs"
            break;
            
        case 4:
            suit = "Diamonds"
            break;
        
        default:
            break;
        }
        
        return suit
    }
    
    func getPic(tempSuit: String, tempName: String)->String {
        let picName = "\(tempSuit)_\(tempName)"
        
        return picName
    }
    
    func addToHands() {
        var i = 0
        
        while i <= 4 {
            hHand[i] = deck[i]
            i += 1
        }
        
        i = 0
        
        while i <= 4 {
            pHand[i] = deck[i + 5]
            i += 1
        }
        
        /*
            hCard1.image = UIImage(named: hHand[0].pic)
            hCard2.image = UIImage(named: hHand[1].pic)
            hCard3.image = UIImage(named: hHand[2].pic)
            hCard4.image = UIImage(named: hHand[3].pic)
            hCard5.image = UIImage(named: hHand[4].pic)
            
            pCard1.image = UIImage(named: pHand[0].pic)
            pCard2.image = UIImage(named: pHand[1].pic)
            pCard3.image = UIImage(named: pHand[2].pic)
            pCard4.image = UIImage(named: pHand[3].pic)
            pCard5.image = UIImage(named: pHand[4].pic)
        */
    }
}

