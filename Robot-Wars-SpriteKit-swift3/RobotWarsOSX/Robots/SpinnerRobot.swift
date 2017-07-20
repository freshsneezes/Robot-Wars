//
//  ThanatosRobot.swift
//  RobotWarsOSX
//
//  Created by its on 17/7/2017.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation

class SpinnerRobot: Robot {
    
    enum RobotState {
        case centre, spinning, firing
    }
    
    var currentRobotState: RobotState = .centre
    
    override func run() {
        while true {
            switch currentRobotState {
            case .centre:
                moveToCentre()
            case .spinning:
                spin()
            case .firing:
                shootAndHope()
            }
        }
    }
    
    //Robot's first move, moving to centre of arena
    func moveToCentre() {
        let arenaSize = arenaDimensions()
        let bodyLength = robotBodySize()
        
        //Turning to centre
        var currentPosition = position()
        //Dealing with x
        var forward = Int(arenaSize.width / 2) - Int(bodyLength.width)
        moveAhead(forward)
        //Dealing with y 
        //Top half
        if currentPosition.y < arenaSize.height / 2 {
            turnLeft(90)
            moveAhead(Int((arenaSize.height / 2) - currentPosition.y))
        }
        //Bottom half
        else {
            turnRight(90)
            moveAhead(Int((arenaSize.height / 2) - currentPosition.y))
        }
        currentRobotState = .spinning
    }
    
    //Spin around wildly
    func spin() {
        turnRight(10)
        //Moving onto firing
        currentRobotState = .firing
    }
    
    //Shoot blindly
    func shootAndHope() {
        shoot()
        //Moving onto spinning
        currentRobotState = .spinning
    }
}
