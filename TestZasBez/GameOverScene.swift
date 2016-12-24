//
//  GameOverScene.swift
//  TestZasBez
//
//  Created by xcode on 26.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

class GameOverScene: UIView{
    func addresult(score:Int32, highscore: Int32){
        let label = UILabel(frame: CGRect(x: self.frame.midX, y: self.frame.minY - 20, width: 200.0, height: 100.0))
        let labelMaxScore = UILabel(frame: CGRect(x: self.frame.midX, y: self.frame.minY + 20, width: 100.0, height: 100.0))
        let labelScore = UILabel(frame: CGRect(x: self.frame.midX, y: self.frame.minY, width: 100.0, height: 100.0))
        if score > highscore {
            label.textColor = SKColor.green
            label.text = String("Conglutination!")
        } else {
            label.textColor = SKColor.red
            label.text = String("Try once more..")
        }
        
        self.addSubview(label)
        labelScore.text = String(score)
        addSubview(labelScore)
        labelMaxScore.text = String(highscore)
        addSubview(labelMaxScore)
    }
    init(frame: CGRect, score: Int32, highscore: Int32) {
        super.init(frame: frame)
        addresult(score: score, highscore: highscore)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
