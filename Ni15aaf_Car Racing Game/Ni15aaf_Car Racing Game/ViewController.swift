//
//  ViewController.swift
//  Ni15aaf_Car Racing Game
//
//  Created by ni15aaf on 26/03/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

protocol SubViewDelegate {
    func movePlayersColissionBounds()
    func resetTimer()
    func showInformationView()
    func playGameButtonPressed()
}



class ViewController: UIViewController, SubViewDelegate, UICollisionBehaviorDelegate {
    @IBOutlet weak var ImgViewRoad: UIImageView!
    @IBOutlet weak var ViewContainer: UIView!
    @IBOutlet weak var ViewInnerContainer: UIView!
    
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    var collisionBehaviour: UICollisionBehavior!
    
    var gameMusic: AVAudioPlayer?
    var collisonSound: AVAudioPlayer?
    var explosionSound: AVAudioPlayer?
    
    //Array for containing roads sections images
    var roadSectsImg: [UIImage]!
    //Array containing cars - player car excluded
    var carsImg: [UIImage]!
    
    var opponentCarsListForCollision: [UIImageView]!
    
    var playerCarImageView: DraggableImageView!
    var pointsCounterView: UILabel!
    
    //Timers
    var gameTimer: Timer!
    
    func showPlayGameScreen(rootView:UIView){
        let rect = CGRect(x: 0, y: 0, width: 100, height: 300)
        
        let startGameViewBottom = UIView(frame: rect)
        let startGameViewContainer = UIView(frame: rect)
        startGameViewBottom.backgroundColor = UIColor.black
        
        let startGameImageView = UIImageView(image: UIImage(named: "start_game.png"))
        
        let gameLogoImageView = UIImageView(frame: rect)
        gameLogoImageView.image = UIImage(named: "logo.png")
        
        let playImageView = playCustomUIImageView(frame: rect, parentView: startGameViewContainer)
        playImageView.parentClassDelegate = self
        playImageView.image = UIImage(named: "play.png")
        playImageView.isUserInteractionEnabled = true
        
        let informationImageView = InformationCustomUIImageView(image: UIImage(named: "info.png"))
        informationImageView.parentClassDelegate = self
        informationImageView.isUserInteractionEnabled = true
        
        startGameViewBottom.addSubview(startGameImageView)
        startGameViewBottom.addSubview(gameLogoImageView)
        startGameViewBottom.addSubview(playImageView)
        startGameViewBottom.addSubview(informationImageView)
        
        informationImageView.translatesAutoresizingMaskIntoConstraints = false
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: informationImageView, attribute: .bottom, relatedBy: .equal, toItem: startGameViewBottom, attribute: .bottom, multiplier: 1, constant: -10))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: informationImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 80))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: informationImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 80))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: informationImageView, attribute: .right, relatedBy: .equal, toItem: startGameViewBottom, attribute:.right, multiplier: 1, constant: -10))
        
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: playImageView, attribute: .top, relatedBy: .equal, toItem: gameLogoImageView, attribute: .bottom, multiplier: 1, constant: 20))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: playImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 150))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: playImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 150))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: playImageView, attribute: .centerX, relatedBy: .equal, toItem: startGameViewBottom, attribute:.centerX, multiplier: 1, constant: 5))
        
        gameLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: gameLogoImageView, attribute: .top, relatedBy: .equal, toItem: startGameViewBottom, attribute: .top, multiplier: 1, constant: 0))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: gameLogoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 100))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: gameLogoImageView, attribute: .leftMargin, relatedBy: .equal, toItem: startGameViewBottom, attribute: .leftMargin,multiplier: 1, constant: 0))
        startGameViewBottom.addConstraint(NSLayoutConstraint(item: gameLogoImageView, attribute: .rightMargin, relatedBy: .equal, toItem: startGameViewBottom, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        
        startGameViewContainer.addSubview(startGameImageView)
        startGameViewContainer.addSubview(startGameViewBottom)
        
        startGameImageView.translatesAutoresizingMaskIntoConstraints = false
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameImageView, attribute: .topMargin, relatedBy: .equal, toItem: startGameViewContainer, attribute: .topMargin, multiplier: 1, constant: 0))
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 250))
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameImageView, attribute: .leftMargin, relatedBy: .equal, toItem: startGameViewContainer, attribute: .leftMargin, multiplier: 1, constant: 0))
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameImageView, attribute: .rightMargin, relatedBy: .equal, toItem: startGameViewContainer, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        startGameViewBottom.translatesAutoresizingMaskIntoConstraints = false
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameViewBottom, attribute: .top, relatedBy: .equal, toItem: startGameImageView, attribute: .bottom, multiplier: 1, constant: 0))
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameViewBottom, attribute: .bottomMargin, relatedBy: .equal, toItem: startGameViewContainer, attribute: .bottomMargin, multiplier: 1, constant: 0))
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameViewBottom, attribute: .leftMargin, relatedBy: .equal, toItem: startGameViewContainer, attribute: .leftMargin,multiplier: 1, constant: 0))
        startGameViewContainer.addConstraint(NSLayoutConstraint(item: startGameViewBottom, attribute: .rightMargin, relatedBy: .equal, toItem: startGameViewContainer, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        rootView.addSubview(startGameViewContainer)
        
        startGameViewContainer.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraint(NSLayoutConstraint(item: startGameViewContainer, attribute: .topMargin, relatedBy: .equal, toItem: rootView, attribute: .topMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: startGameViewContainer, attribute: .bottomMargin, relatedBy: .equal, toItem: rootView, attribute: .bottomMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: startGameViewContainer, attribute: .leftMargin, relatedBy: .equal, toItem: rootView, attribute: .leftMargin,multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: startGameViewContainer, attribute: .rightMargin, relatedBy: .equal, toItem: rootView, attribute: .rightMargin, multiplier: 1, constant: 0))
    }
    
    func showInformationView(){
        let rootView: UIView = ViewContainer //**
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 300)
        
        let informationViewConatiner = UIView(frame: rect)
        
        var infoPicArr: [UIImage]! = [UIImage]()
        let infoImageView = UIImageView(frame: rect)
        for num in 1...2{
            var fileName: String = "help"
            fileName+=String(num)
            fileName+=".png"
            infoPicArr.append(UIImage(named:fileName)!)
        }
        infoImageView.image = UIImage.animatedImage(with: infoPicArr, duration: 7)
        
        let exitImageView = ExitCustomUIImageView(frame: rect, parentView: informationViewConatiner)
        exitImageView.image = UIImage(named: "exit.png")
        exitImageView.isUserInteractionEnabled = true
        
        informationViewConatiner.addSubview(infoImageView)
        informationViewConatiner.addSubview(exitImageView)
    
        exitImageView.translatesAutoresizingMaskIntoConstraints = false
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: exitImageView, attribute: .top, relatedBy: .equal, toItem: informationViewConatiner, attribute: .top, multiplier: 1, constant: 5))
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: exitImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 50))
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: exitImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 50))
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: exitImageView, attribute: .right, relatedBy: .equal, toItem: informationViewConatiner, attribute:.right, multiplier: 1, constant: -5))
        
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: infoImageView, attribute: .topMargin, relatedBy: .equal, toItem: informationViewConatiner, attribute: .topMargin, multiplier: 1, constant: 0))
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: infoImageView, attribute: .bottomMargin, relatedBy: .equal, toItem: informationViewConatiner, attribute: .bottomMargin, multiplier: 1, constant: 0))
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: infoImageView, attribute: .leftMargin, relatedBy: .equal, toItem: informationViewConatiner, attribute: .leftMargin,multiplier: 1, constant: 0))
        informationViewConatiner.addConstraint(NSLayoutConstraint(item: infoImageView, attribute: .rightMargin, relatedBy: .equal, toItem: informationViewConatiner, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        rootView.addSubview(informationViewConatiner)
        
        informationViewConatiner.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraint(NSLayoutConstraint(item: informationViewConatiner, attribute: .topMargin, relatedBy: .equal, toItem: rootView, attribute: .topMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: informationViewConatiner, attribute: .bottomMargin, relatedBy: .equal, toItem: rootView, attribute: .bottomMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: informationViewConatiner, attribute: .leftMargin, relatedBy: .equal, toItem: rootView, attribute: .leftMargin,multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: informationViewConatiner, attribute: .rightMargin, relatedBy: .equal, toItem: rootView, attribute: .rightMargin, multiplier: 1, constant: 0))
    }
    
    func showGameOverScreen(rootView:UIView, points:Int){
        let rect = CGRect(x: 0, y: 0, width: 100, height: 300)
        
        let gameOverView = UIView(frame: rect)
        gameOverView.backgroundColor = UIColor.black
        
        let gameOverImageView = UIImageView(image: UIImage(named:"game_over.jpg"))
        
        let pointsLabelView = UILabel(frame: rect)
        pointsLabelView.numberOfLines = 0 // to support multi lines
        pointsLabelView.text = String(points)+" Points!"
        pointsLabelView.font = UIFont.boldSystemFont(ofSize: 27)
        pointsLabelView.textColor = UIColor.white
        pointsLabelView.textAlignment = .center
        
        if saveBestScore(points) {
            pointsLabelView.text! += "\n\nNew best score: "+String(points)+" Points!"
        }
        else{
            pointsLabelView.text! += "\n\nBest score: "+String(getBestScore()!.score)+" Points"
        }
        
        
        let replayImageView = replayCustomUIImageView(frame: rect, parentView: gameOverView)
        replayImageView.parentClassDelegate = self
        replayImageView.image = UIImage(named: "replay.png")
        replayImageView.isUserInteractionEnabled = true
        
        
        gameOverView.addSubview(gameOverImageView)
        gameOverView.addSubview(pointsLabelView)
        gameOverView.addSubview(replayImageView)
        
        replayImageView.translatesAutoresizingMaskIntoConstraints=false
        gameOverView.addConstraint(NSLayoutConstraint(item: replayImageView, attribute: .top, relatedBy: .equal, toItem: pointsLabelView, attribute: .bottom, multiplier: 1, constant: 20))
        gameOverView.addConstraint(NSLayoutConstraint(item: replayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 150))
        gameOverView.addConstraint(NSLayoutConstraint(item: replayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 150))
        gameOverView.addConstraint(NSLayoutConstraint(item: replayImageView, attribute: .centerX, relatedBy: .equal, toItem: gameOverView, attribute:.centerX, multiplier: 1, constant: 5))
        
        pointsLabelView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.addConstraint(NSLayoutConstraint(item: pointsLabelView, attribute: .top, relatedBy: .equal, toItem: gameOverImageView, attribute: .bottom, multiplier: 1, constant: 10))
        gameOverView.addConstraint(NSLayoutConstraint(item: pointsLabelView, attribute: .leftMargin, relatedBy: .equal, toItem: gameOverView, attribute: .leftMargin,multiplier: 1, constant: 0))
        gameOverView.addConstraint(NSLayoutConstraint(item: pointsLabelView, attribute: .rightMargin, relatedBy: .equal, toItem: gameOverView, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        
        gameOverImageView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.addConstraint(NSLayoutConstraint(item: gameOverImageView, attribute: .topMargin, relatedBy: .equal, toItem: gameOverView, attribute: .topMargin, multiplier: 1, constant: 0))
        gameOverView.addConstraint(NSLayoutConstraint(item: gameOverImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 250))
        gameOverView.addConstraint(NSLayoutConstraint(item: gameOverImageView, attribute: .leftMargin, relatedBy: .equal, toItem: gameOverView, attribute: .leftMargin,multiplier: 1, constant: 0))
        gameOverView.addConstraint(NSLayoutConstraint(item: gameOverImageView, attribute: .rightMargin, relatedBy: .equal, toItem: gameOverView, attribute: .rightMargin, multiplier: 1, constant: 0))

        rootView.addSubview(gameOverView)
        
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .topMargin, relatedBy: .equal, toItem: rootView, attribute: .topMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .bottomMargin, relatedBy: .equal, toItem: rootView, attribute:.bottomMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .leftMargin, relatedBy: .equal, toItem: rootView, attribute: .leftMargin,multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .rightMargin, relatedBy: .equal, toItem: rootView, attribute: .rightMargin, multiplier: 1, constant: 0))
        
        rootView.bringSubview(toFront: gameOverView)
        
    }
    
    func setRoadImgs(){
        for num in 1...20{
            var fileName: String = "road"
            fileName+=String(num)
            fileName+=".png"
            roadSectsImg.append(UIImage(named:fileName)!)
        }
    }
    
    func setOtherCarsImgs(){
        for num in 1...6{ // note I start from 1 as 0 is the player car
            var fileName: String = "car"
            fileName+=String(num)
            fileName+=".png"
            carsImg.append(UIImage(named:fileName)!)
        }
    }
    
    func setCounterOnScreen(rootView: UIView){
        let rect = CGRect(x: 0, y: 0, width: 100, height: 300)
        pointsCounterView = UILabel(frame: rect)
        pointsCounterView.text = "0"
        pointsCounterView.font = UIFont.boldSystemFont(ofSize: 25)
        pointsCounterView.textColor = UIColor.red
        rootView.addSubview(pointsCounterView)
        
        pointsCounterView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraint(NSLayoutConstraint(item: pointsCounterView, attribute: .top, relatedBy: .equal, toItem: rootView, attribute: .top, multiplier: 1, constant: 5))
        rootView.addConstraint(NSLayoutConstraint(item: pointsCounterView, attribute: .right, relatedBy: .equal, toItem: rootView, attribute:.right, multiplier: 1, constant: -10))
    }
    
    func incrementPointsCounter(amount: Int){
        let points: Int = Int(pointsCounterView.text!)!
        pointsCounterView.text = String(points+amount)
    }
    
    func addPlayerCar(rootView: UIView){
        playerCarImageView = DraggableImageView(image: UIImage(named: "car0.png"))
        playerCarImageView.isUserInteractionEnabled = true
        rootView.addSubview(playerCarImageView);
        
        playerCarImageView.translatesAutoresizingMaskIntoConstraints = false
        //Image size proportion 382x757 => new size 382:757=70:x
        rootView.addConstraint(NSLayoutConstraint(item: playerCarImageView, attribute: .centerY, relatedBy: .equal, toItem: rootView, attribute: .bottom, multiplier: 1, constant: -138))
        rootView.addConstraint(NSLayoutConstraint(item: playerCarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 138))
        rootView.addConstraint(NSLayoutConstraint(item: playerCarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute, multiplier: 1, constant: 70))
        rootView.addConstraint(NSLayoutConstraint(item: playerCarImageView, attribute: .centerX, relatedBy: .equal, toItem: rootView, attribute:.centerX, multiplier: 1, constant: 5))
    }
    
    func random(_ range:Range<Int>) -> Int
    {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    func generateCarFall(rootView: UIView){
        //Setting horizontal boundary range
        let minX = Int(rootView.bounds.size.width*(15*0.01)) //15% screen size
        let maxX = Int(rootView.bounds.size.width)-minX
        
        //create and ImageView
        let posX = random(minX..<maxX)
        
        let rect = CGRect(x: posX, y: 0, width: 50, height: 90)
        let obstacleCar = ObstacleCarUIImage(frame: rect)
        obstacleCar.image = carsImg[random(0..<6)]
        
        rootView.addSubview(obstacleCar)
        
        //At each generation ad 10 points to score **
        incrementPointsCounter(amount: 10)
        
        dynamicItemBehaviour = UIDynamicItemBehavior(items:[obstacleCar])
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: 0, y: 300), for: obstacleCar)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
        
        if(!opponentCarsListForCollision.contains(obstacleCar)){
            opponentCarsListForCollision.append(obstacleCar)
        }
        
        collisionBehaviour = UICollisionBehavior(items: opponentCarsListForCollision)
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = false
        if playerCarImageView != nil {
            collisionBehaviour.addBoundary(withIdentifier: "MainCarBoundary" as NSCopying, for: UIBezierPath(rect: playerCarImageView.frame))
        }
        collisionBehaviour.collisionDelegate =  self
        dynamicAnimator.addBehavior(collisionBehaviour)
    }
    
    func playGameMusic(){
        let path = Bundle.main.path(forResource: "off_limits.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            gameMusic = try AVAudioPlayer(contentsOf: url)
            //set sounds to be played infinitely
            gameMusic?.numberOfLoops = -1
            
            gameMusic?.play()
        } catch {
            NSLog("can't load the game music")
        }
        
    }
    
    func playCollisionSound(){
        let path = Bundle.main.path(forResource: "collision.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            collisonSound = try AVAudioPlayer(contentsOf: url)
            collisonSound?.play()
        } catch {
            NSLog("can't load the collision sound")
        }
    }
    
    func playExplosionSound(){
        let path = Bundle.main.path(forResource: "explosion.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            explosionSound = try AVAudioPlayer(contentsOf: url)
            explosionSound?.play()
        } catch {
            NSLog("can't load the explosion sound")
        }
    }
    
    func movePlayersColissionBounds(){
        if collisionBehaviour != nil {
            collisionBehaviour.removeAllBoundaries();
            collisionBehaviour.addBoundary(withIdentifier: "MainCarBoundary" as NSCopying, for: UIBezierPath(rect: playerCarImageView.frame))
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        pointsCounterView.text = "0" //At each collision loose points
        
        playCollisionSound()
        
        //vibrate
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //make obstacle car explode
        let obstacleCar = item as! UIImageView
        let when = DispatchTime.now() + DispatchTimeInterval.seconds(2)
        DispatchQueue.main.asyncAfter(deadline: when) {
            let index = self.opponentCarsListForCollision.index(of: obstacleCar)
            if index != nil {
                self.opponentCarsListForCollision.remove(at: index!)
            }
            
            self.playExplosionSound()
            
            obstacleCar.image = UIImage(named: "explosion.png")
        }
    }
    
    @objc func runTimedCode(){
        let when = DispatchTime.now() + DispatchTimeInterval.seconds(random(0..<3))
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.generateCarFall(rootView: self.ViewInnerContainer)
        }
    }
    
    func resetTimer(){
        //Reset points
        self.pointsCounterView.text = "0"
        startGameTimer()
        setGameDuration()
    }
    
    func startGameTimer(){
        //initialise the array
        self.opponentCarsListForCollision = [UIImageView]()
        
        //Display player car
        addPlayerCar(rootView: ViewContainer)
        playerCarImageView.parentClassDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func setGameDuration(){
        //Game termination after 20 seconds **
        let when = DispatchTime.now() + DispatchTimeInterval.seconds(20)
        DispatchQueue.main.asyncAfter(deadline: when) {
            //stop timer
            self.gameTimer.invalidate()
            
            //remove all opposing cars
            for view in self.ViewInnerContainer.subviews {
                if let car = view as? UIImageView {
                    if car.bounds.width == 50 && car.bounds.height == 90{
                        car.removeFromSuperview()
                    }
                }
            }
            self.opponentCarsListForCollision = [UIImageView]()
            
            //remove all behaviors
            self.dynamicAnimator.removeAllBehaviors()
            
            //Get points to display
            let finalPoints: Int = Int(self.pointsCounterView.text!)!
            
            //Player Car reset
            self.playerCarImageView.removeFromSuperview()
            self.playerCarImageView = nil
            
            //Showing the game over screen
            self.showGameOverScreen(rootView: self.ViewContainer, points: finalPoints)
        }
    }
    
    func playGameButtonPressed(){
        dynamicAnimator = UIDynamicAnimator(referenceView: ViewInnerContainer)
        
        //Initilaise the array that will keep track of all opposing cars in the game.
        opponentCarsListForCollision = [UIImageView]()
        
        //Setting all road Images for the animation
        roadSectsImg = [UIImage]()
        setRoadImgs()
        
        //Setting the road motion effect to main ImageView
        ImgViewRoad.image = UIImage.animatedImage(with: roadSectsImg, duration: 0.5)
        
        //Setting all opposing cars
        carsImg = [UIImage]()
        setOtherCarsImgs()
        
        //Show game points counter on screen
        setCounterOnScreen(rootView: ViewInnerContainer)
        
        //Start all game timing
        startGameTimer()
        setGameDuration()
    }
    
    func saveBestScore(_ score: Int) -> Bool{
        let pastBestScore = getBestScore()
        if pastBestScore != nil {
            var newBestScore: Bool! = true
            if max(pastBestScore!.score,score) == pastBestScore!.score {
                newBestScore = false
            }
            else{
                let bestScore = BestScore(score: max(pastBestScore!.score,score))
                NSKeyedArchiver.archiveRootObject(bestScore, toFile: BestScore.ArchiveURL.path)
            }
            return newBestScore
        }
        else{
            let bestScore = BestScore(score: score)
            NSKeyedArchiver.archiveRootObject(bestScore, toFile: BestScore.ArchiveURL.path)
            return true
        }
    }
    
    func getBestScore() -> BestScore? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: BestScore.ArchiveURL.path) as? BestScore
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //playing game music
        playGameMusic()
        
        //Setting the road and its motion effect to main ImageView
        roadSectsImg = [UIImage]()
        setRoadImgs()
        ImgViewRoad.image = UIImage.animatedImage(with: roadSectsImg, duration: 0.5)
        
        //Show main starting screen
        showPlayGameScreen(rootView: ViewContainer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

