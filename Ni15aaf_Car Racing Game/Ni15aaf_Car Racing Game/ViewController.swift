//
//  ViewController.swift
//  Ni15aaf_Car Racing Game
//
//  Created by ni15aaf on 26/03/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var ImgViewRoad: UIImageView!
    @IBOutlet weak var ViewContainer: UIView!
    
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    
    //Array for containing roads sections images
    var roadSectsImg: [UIImage]!
    //Array containing cars - player car excluded
    var carsImg: [UIImage]!
    
    var playerCarImageView: UIImageView!
    var pointsCounterView: UILabel!
    
    func showGameOverScreen(rootView:UIView, points:Int){
        let rect = CGRect(x: 0, y: 0, width: 100, height: 300)
        
        let gameOverView = UIView(frame: rect)
        gameOverView.backgroundColor = UIColor.black
        
        let gameOverImageView = UIImageView(frame: rect)
        gameOverImageView.image = UIImage(named:"game_over.jpg")
        
        let pointsLabelView = UILabel(frame: rect)
        pointsLabelView.text = String(points)+" Points!"
        pointsLabelView.font = UIFont.boldSystemFont(ofSize: 35)
        pointsLabelView.textColor = UIColor.white
        pointsLabelView.textAlignment = .center
        
        //Not so anonymous class definition
        class replayCustomUIImageView: UIImageView {
            
            private var _parentView: UIView?
            
            override init(image: UIImage?) {
                super.init(image: image)
                _parentView = nil
            }
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                _parentView = nil
            }
            
            required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
                _parentView = nil
            }
            
            init(frame: CGRect, parentView: UIView) {
                super.init(frame: frame)
                _parentView = parentView
            }
            
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                _parentView!.removeFromSuperview()
            }
        }
        
        let replayImageView = replayCustomUIImageView(frame: rect, parentView: gameOverView)
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

        rootView.addSubview(gameOverView);
        
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .topMargin, relatedBy: .equal, toItem: rootView, attribute: .topMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .bottomMargin, relatedBy: .equal, toItem: rootView, attribute:.bottomMargin, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .leftMargin, relatedBy: .equal, toItem: rootView, attribute: .leftMargin,multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: gameOverView, attribute: .rightMargin, relatedBy: .equal, toItem: rootView, attribute: .rightMargin, multiplier: 1, constant: 0))
        
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
        let rect = CGRect(x: 0, y: 0, width: 100, height: 300)
        
        playerCarImageView = DraggableImageView(frame: rect)
        playerCarImageView.image = UIImage(named: "car0.png")
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
        let minX = Int(rootView.bounds.size.width*(15*0.01)) //15% scree size
        let maxX = Int(rootView.bounds.size.width)-minX
        
        //create and ImageView
        let posX = random(minX..<maxX+1)
        
        let rect = CGRect(x: posX, y: 10, width: 50, height: 90)
        let obstacleCar = UIImageView(frame: rect)
        obstacleCar.image = carsImg[random(0..<6)]
        
        rootView.addSubview(obstacleCar)
        
        dynamicItemBehaviour = UIDynamicItemBehavior(items:[obstacleCar])
        dynamicItemBehaviour.addLinearVelocity(CGPoint(x: 0, y: 300), for: obstacleCar)
        dynamicAnimator.addBehavior(dynamicItemBehaviour)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dynamicAnimator = UIDynamicAnimator(referenceView: ViewContainer)
        
        //Setting all road Images for the animation
        roadSectsImg = [UIImage]()
        setRoadImgs()
        
        //Setting the road motion effect to main ImageView
        ImgViewRoad.image = UIImage.animatedImage(with: roadSectsImg, duration: 0.5)
        
        //Setting all opposing cars
        carsImg = [UIImage]()
        setOtherCarsImgs()
        
        //Show game points counter on screen
        setCounterOnScreen(rootView: ViewContainer)
        
        //Display player car
        addPlayerCar(rootView: ViewContainer)
        generateCarFall(rootView: ViewContainer)
        
        incrementPointsCounter(amount: 0)
        //Showing the game over screen
        //showGameOverScreen(rootView: ViewContainer, points: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

