//
//  ViewController.swift
//  MemoryOfSimon
//
//  Created by 周祺华 on 2017/1/4.
//  Copyright © 2017年 周祺华. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {
    
    enum ButtonColor : Int {
        case Red = 1
        case Green = 2
        case Blue = 3
        case Yellow = 4
    }
    
    enum WhoseTurn {
        case Human
        case Computer
    }
    
    // 与视图相关的对象和变量
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var roundCount: UILabel!
    
    // 与模型相关的对象和变量
    let winningNumber : Int = 3
    var currentPlayer : WhoseTurn = .Computer
    var inputs = [ButtonColor]() // 存储sequence数组
    var indexOfNextButtonToTouch: Int = 0
    var hightSquareTime = 0.5
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startNewGame()
    }
    
    func buttonByColor(color: ButtonColor) -> UIButton {
        switch color {
        case .Red:
            return redButton
        case .Green:
            return greenButton
        case .Blue:
            return blueButton
        case .Yellow:
            return yellowButton
        }
    }
    
    func playSequence(index: Int, highlightTime: Double) {
        roundCount.text = "Round:" + inputs.count.description
        
        currentPlayer = .Computer
        
        if index == inputs.count {
            currentPlayer = .Human
            return
        }
        
        let button: UIButton = buttonByColor(color: inputs[index])
        let originalColor: UIColor? = button.backgroundColor
        let highlightColor: UIColor = UIColor.white
        
        UIView.animate(withDuration: highlightTime,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveLinear.intersection(.allowUserInteraction).intersection(.beginFromCurrentState),
                       animations: {
            button.backgroundColor = highlightColor
        },
                       completion: { finished in
            button.backgroundColor = originalColor
            let newIndex: Int = index+1
            self.playSequence(index: newIndex, highlightTime: highlightTime)
        })
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        let buttonTag: Int = sender.tag
        
        if let colorTouched = ButtonColor(rawValue: buttonTag) {
            if currentPlayer == .Computer {
                // 只要这个条件为true，就忽略触摸
                return
            }
            
            if colorTouched == inputs[indexOfNextButtonToTouch] {
                // 玩家触摸了正确的按钮
                indexOfNextButtonToTouch += 1
                
                // 判断这一轮是否还有其他按钮要触摸
                if indexOfNextButtonToTouch == inputs.count {
                    // 玩家成功地完成了这一轮
                    if advanceGame() == false {
                        playerWins()
                    }
                    indexOfNextButtonToTouch = 0
                }
                else {
                    // 还有其他按钮需要触摸
                }
            }
            else {
                // 玩家触摸的按钮不对
                playerLoses()
                indexOfNextButtonToTouch = 0
            }
            
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        startNewGame()
    }
    
    func playerWins() {
        let winner: UIAlertView = UIAlertView(title: "You won!", message: "Congratulations!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Awesome!")
        winner.show()
    }
    
    func playerLoses() {
        let loser: UIAlertView = UIAlertView(title: "You lost!", message: "Sorry!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Try again!")
        loser.show()
        
    }
    
    func randomButton() -> ButtonColor {
        let v: Int = Int(arc4random_uniform(UInt32(4))) + 1
        let result = ButtonColor(rawValue: v)
        return result!
    }
    
    func startNewGame() {
        // 生成随机的输入数组
        inputs = [ButtonColor]()
        advanceGame()
    }
    
    func advanceGame() -> Bool {
        var result: Bool = true
        
        if inputs.count == winningNumber {
            result = false
        }
        else {
            // 亮起一个按钮或等待玩家开始触摸按钮
            inputs += [randomButton()]
            
            // play the button sequence and delay 1 second
            let delay = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: { 
                self.playSequence(index: 0, highlightTime: self.hightSquareTime)
            })
        }
        
        return result
    }
    
}

