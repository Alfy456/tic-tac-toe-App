//
//  ViewController.swift
//  TicTacToe-template
//
//  Created by Mohammad Kiani on 2020-06-08.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var label: UILabel!
    
    //setting the score to zero
    var crossMark = 0
    var noughtMark = 0
    
    @IBOutlet weak var scoreofNought: UILabel!
    @IBOutlet weak var scoreofCross: UILabel!
    var game = [Game]()
    var count = 1
    var activePlayer = 1 //cross
    var gameState = [0,0,0,0,0,0,0,0,0]//setting each state with zero
    var gameIsActive = true
    //defining every winning states
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
   
    var isShake = true
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        //2nd step - to get the context
        let context = appDelegate.persistentContainer.viewContext
                //shake gesture response
        self.becomeFirstResponder()
        
   fetchData(context)
    }
    
    override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  fetchData()
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
           
            debugPrint(gameState)
           
        }
        
        for combination in winningCombinations {
            if (gameState[combination[0]] != 0 && gameState[combination[0]] ==  gameState[combination[1]] &&  gameState[combination[1]] ==  gameState[combination[2]]){
            
            gameIsActive = false
            
               
            
            if gameState[combination[0]] == 1{
                label.text = "Cross has won!"
                crossMark += 1
                scoreofCross.text = String(crossMark)
                print(crossMark)
              saveDetail(itemDetail: String(crossMark), key: "scoreX")
                
            }else{
                label.text = "Cricle has won"
                noughtMark += 1
                scoreofNought.text = String(noughtMark)
                print(noughtMark)
                saveDetail(itemDetail: String(noughtMark), key: "scoreO")
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake{
            
            print("Shake")
        
                
        
        }
    }
    
    func saveDetail(itemDetail: String,key:String) {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Game", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
       // let entity = NSEntityDescription.insertNewObject(forEntityName: "Game", into: context)
       // let manageObject = NSManagedObject(entity: entity, insertInto: context)
        
      newUser.setValue(itemDetail, forKey: key)
       do {
           try context.save()
        } catch {
          print(error)
       }
    }
    
    func fetchData(_ context: NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
       
        do{
        let results = try context.fetch(request)
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    if let scoreX = result.value(forKey: "scoreX"){
                        let x = scoreX as! String
                    
                        print("X :\(x)")
                    }
                    if let scoreO = result.value(forKey: "scoreO"){
                        let o = scoreO as! String
                        
                        print("O :\(o)")
                        
                      
                    }
                    
                    //update the context
                    try  appDelegate.saveContext()
                    
                    
                    print("*************")
                    
                }
            }
        }catch{
            print(error)
        }    }
}

