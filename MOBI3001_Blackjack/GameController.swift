//
//  GameController.swift
//  MOBI3001_Blackjack
//
//  Created by w0454732 on 2022-04-14.
//

import UIKit
import CoreData

class GameController: UIViewController {
    //setting up all the items in this view.
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
    @IBOutlet weak var plyrPoints: UILabel!
    
    @IBOutlet weak var bttnHit: UIButton!
    @IBOutlet weak var bttnStnd: UIButton!
    @IBOutlet weak var bttnStrt: UIButton!
    
    //setting up a context vaiable to be used later for core data
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //setting up a class for a card
    class card {
        //varibles used in the class
        var name: String
        var value: Int
        var pic: String
        
        //initializer for the class
        init(name: String, value: Int, pic: String) {
            self.name = name
            self.value = value
            self.pic = pic
        }
    }
    
    //setting up variables to be used later on
    var deck: [card] = [card](repeating: card(name: "", value: 0, pic: ""), count: 52)
    
    var hHand: [card] = [card](repeating: card(name: "", value: 0, pic: ""), count: 5)
    var hValue = 0
    
    var pHand: [card] = [card](repeating: card(name: "", value: 0, pic: ""), count: 5)
    var pValue = 0
    var ptsTtl = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up variables to be used in the while loops
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
        
        //shuffling the deck array
        deck.shuffle();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //getting the players name each time the user enters the tab so that any changes will happen
        let players =  try! appContext.fetch(UserPlayer.fetchRequest())
        
        for player in players {
            ptsTtl = Int((player as! UserPlayer).points)
            plyrPoints.text = "Player Points: \(ptsTtl)"
            
            plyrTitle.text = "\(((player as! UserPlayer).name)!)'s Hand"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //when this tab is left the player's points are saved to Core Data to be shown later
        let players =  try! appContext.fetch(UserPlayer.fetchRequest())
        
        for player in players {
            (player as! UserPlayer).points = Int32(ptsTtl)
        }
        
        try! appContext.save()
    }
    
    @IBAction func pressedHit(_ sender: UIButton) {
        //displays the next unshown card
        if(pCard3.isHidden) {
            pCard3.isHidden = false
        } else if(pCard4.isHidden) {
            pCard4.isHidden = false
        } else if(pCard5.isHidden) {
            //if five cards are in the players hand it automatically swaps to the house's turn
            pCard5.isHidden = false
            calcPlyrHand()
            houseTurn()
            return
        }
        
        calcPlyrHand()
    }
    
    @IBAction func pressedStand(_ sender: UIButton) {
        //the user stands leading to the house's turn
        houseTurn()
    }
    
    @IBAction func pressedStart(_ sender: UIButton) {
        //shuffles the deck and adds the cards to the hand
        deck.shuffle()
        addToHands()
        
        //sets the visibility and the images of the first two cards of each hand
        bttnStrt.isHidden = true
        bttnHit.isHidden = false
        bttnStnd.isHidden = false
        
        pCard1.image = UIImage(named: pHand[0].pic)
        pCard2.image = UIImage(named: pHand[1].pic)
        pCard3.isHidden = true
        pCard4.isHidden = true
        pCard5.isHidden = true
        
        hCard1.image = UIImage(named: hHand[0].pic)
        hCard3.isHidden = true
        hCard4.isHidden = true
        hCard5.isHidden = true
        
        //calculates the totals for each hand
        calcPlyrHand()
        calcHouseHand()
    }
    
    //function to add all the cards to the deck
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
        
        pic = getPic(tempSuit: suit, tempName: name, tempValue: value)
        
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
    
    func getPic(tempSuit: String, tempName: String, tempValue: Int)->String {
        var picName: String
        
        if tempValue < 10 {
            picName = "card_\(tempSuit.lowercased())_0\(tempName)"
        } else {
            picName = "card_\(tempSuit.lowercased())_\(tempName)"
        }
        
        return picName
    }
    
    //adding the cards to the hands
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
        
        //setting the images
        hCard1.image = UIImage(named: "card_back")
        hCard2.image = UIImage(named: "card_back")
        hCard3.image = UIImage(named: hHand[2].pic)
        hCard4.image = UIImage(named: hHand[3].pic)
        hCard5.image = UIImage(named: hHand[4].pic)
        
        pCard1.image = UIImage(named: "card_back")
        pCard2.image = UIImage(named: "card_back")
        pCard3.image = UIImage(named: pHand[2].pic)
        pCard4.image = UIImage(named: pHand[3].pic)
        pCard5.image = UIImage(named: pHand[4].pic)
    }
    
    //calculating the value of the displayed cards while taking into consideration if the ace should be a 1 or an 11
    func calcPlyrHand(){
        pValue = 0
        
        if(!pCard1.isHidden && pCard1.image != UIImage(named: "card_back")) {
            if(pHand[0].value == 11 && (pValue + 11) > 21) {
                pValue += 1
            } else {
                pValue += pHand[0].value
            }
        }
        if(!pCard2.isHidden && pCard2.image != UIImage(named: "card_back")) {
            if(pHand[1].value == 11 && (pValue + 11) > 21) {
                pValue += 1
            } else {
                pValue += pHand[1].value
            }
        }
        if(!pCard3.isHidden) {
            if(pHand[2].value == 11 && (pValue + 11) > 21) {
                pValue += 1
            } else {
                pValue += pHand[2].value
            }
        }
        if(!pCard4.isHidden) {
            if(pHand[3].value == 11 && (pValue + 11) > 21) {
                pValue += 1
            } else {
                pValue += pHand[3].value
            }
        }
        if(!pCard5.isHidden) {
            if(pHand[4].value == 11 && (pValue + 11) > 21) {
                pValue += 1
            } else {
                pValue += pHand[4].value
            }
        }
        
        //sets the text on screen to display the current card value
        plyrTotal.text = "Hand Total: \(pValue)"
        
        //seeing if the user wins or loses
        if(pValue >= 22) {
            ptsTtl -= 50
            plyrPoints.text = "Player Points: \(ptsTtl)"
            
            callAlert(state: "lose")
        } else if(pValue == 21) {
            ptsTtl += 50
            plyrPoints.text = "Player Points: \(ptsTtl)"
            
            callAlert(state: "win")
        }
    }
    
    //calculates the houses value (same as the player one other than win/lose conditions)
    func calcHouseHand(){
        hValue = 0
        
        if(!hCard1.isHidden && hCard1.image != UIImage(named: "card_back")) {
            if(hHand[0].value == 11 && (hValue + 11) > 21) {
                hValue += 1
            } else {
                hValue += hHand[0].value
            }
        }
        if(!hCard2.isHidden && hCard2.image != UIImage(named: "card_back")) {
            if(hHand[1].value == 11 && (hValue + 11) > 21) {
                hValue += 1
            } else {
                hValue += hHand[1].value
            }
        }
        if(!hCard3.isHidden) {
            if(hHand[2].value == 11 && (hValue + 11) > 21) {
                hValue += 1
            } else {
                hValue += hHand[2].value
            }
        }
        if(!hCard4.isHidden) {
            if(hHand[3].value == 11 && (hValue + 11) > 21) {
                hValue += 1
            } else {
                hValue += hHand[3].value
            }
        }
        if(!hCard5.isHidden) {
            if(hHand[4].value == 11 && (hValue + 11) > 21) {
                hValue += 1
            } else {
                hValue += hHand[4].value
            }
        }
        houseTotal.text = "Hand Total: \(hValue)"
    }
    
    //logic behind the house's play
    func houseTurn() {
        //only draws if the value is lower than 21, lower than the players hand value, and the fifth card is hidden
        while(hValue < 21 && hValue < pValue && hCard5.isHidden) {
            if(hCard2.image == UIImage(named: "card_back")) {
                hCard2.image = UIImage(named: hHand[1].pic)
            } else if(hCard3.isHidden) {
                hCard3.isHidden = false
            } else if(hCard4.isHidden) {
                hCard4.isHidden = false
            } else if(hCard5.isHidden) {
                hCard5.isHidden = false
            }
            
            calcHouseHand()
        }
        
        //checks to see if the player or the house wins
        if(hValue <= 21 && hValue >= pValue) {
            ptsTtl -= 50
            plyrPoints.text = "Player Points: \(ptsTtl)"
            
            callAlert(state: "lose")
        } else if(hValue > 21 || hValue < pValue) {
            ptsTtl += 50
            plyrPoints.text = "Player Points: \(ptsTtl)"
            
            callAlert(state: "win")
        }
    }
    
    //function to call an alert, either win or lose
    func callAlert(state: String) {
        var alertOut: UIAlertController
        
        //if statement to change the message shown
        if(state == "win"){
            alertOut = UIAlertController(title: "You Win", message: "Click Dismiss To End The Game And Start A New One", preferredStyle: .alert);
        } else {
            alertOut = UIAlertController(title: "You Lose", message: "Click Dismiss To End The Game And Start A New One", preferredStyle: .alert);
        }
        
        //adds and displays the alert. Dismiss calls the endGame() function
        let clsAction = UIAlertAction(title: "Dismiss", style: .default, handler: {(_) in self.endGame()})
        alertOut.addAction(clsAction);
        present(alertOut, animated: true, completion: nil);
    }
    
    //ends the game by resetting the apps visibilities, images, and labels
    func endGame() {
        bttnStrt.isHidden = false
        bttnHit.isHidden = true
        bttnStnd.isHidden = true
        
        pCard1.image = UIImage(named: "card_back")
        pCard2.image = UIImage(named: "card_back")
        pCard3.isHidden = true
        pCard4.isHidden = true
        pCard5.isHidden = true
        
        hCard1.image = UIImage(named: "card_back")
        hCard2.image = UIImage(named: "card_back")
        hCard3.isHidden = true
        hCard4.isHidden = true
        hCard5.isHidden = true
        
        calcPlyrHand()
        calcHouseHand()
    }
}
