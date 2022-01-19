//
//  ViewController.swift
//  TicTacToe-template
//
//  Created by Mohammad Kiani on 2020-06-08.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var label: UILabel!
    
    //setting the score to zero
    var crossMark = 0
    var noughtMark = 0
    
    @IBOutlet weak var scoreofNought: UILabel!
    @IBOutlet weak var scoreofCross: UILabel!
    
    
    var count = 1
    var activePlayer = 1 //cross
    var gameState = [0,0,0,0,0,0,0,0,0]//setting each state with zero
    var gameIsActive = true
    //defining every winning states
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }

    @IBAction func action(_ sender: AnyObject) {
        if(gameState[sender.tag-1] == 0 && gameIsActive == true){
            
            //update gamestate to the activeplayer
            gameState[sender.tag-1] = activePlayer
            if(activePlayer == 1){
                sender.setImage(UIImage(named: "cross.png"), for: UIControl.State())
                activePlayer = 2
            }else{
                 sender.setImage(UIImage(named: "nought.png"), for: UIControl.State())
                 activePlayer = 1
            }
        }
        
        for combination in winningCombinations {
            if (gameState[combination[0]] != 0 && gameState[combination[0]] ==  gameState[combination[1]] &&  gameState[combination[1]] ==  gameState[combination[2]]){
            
            gameIsActive = false
            
            
            if gameState[combination[0]] == 1{
                label.text = "Cross has won!"
                crossMark += 1
                scoreofCross.text = String(crossMark)
                print(crossMark)
              
                
            }else{
                label.text = "Cricle has won"
                noughtMark += 1
                scoreofNought.text = String(noughtMark)
                print(noughtMark)
                
            }
                label.isHidden = false
            }
        }
                gameIsActive = false
        //check whether a space left for user to play
                for i in gameState{
                    if i == 0{
                        gameIsActive = true
                        break
                    }
                }
        
                if gameIsActive == false{
                    label.text = "It was a draw!"
                    label.isHidden = false
                    
                }
            
            
        }
    
    
    
    //swipe gesture to refresh the game
    @objc func swiped(gesture: UISwipeGestureRecognizer){
        let swipeGesture = gesture as UISwipeGestureRecognizer
        switch swipeGesture.direction{
      
        case .up:
            
            activePlayer = 1
            gameState = [0,0,0,0,0,0,0,0,0]
            gameIsActive = true
           label.isHidden = true
           
           for i in 1...9{
               let button = view.viewWithTag(i) as! UIButton
               button.setImage(nil, for: UIControl.State())
           }
                
        default:
            break
        
        }
    }
    
    
}

