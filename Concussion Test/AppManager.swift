//
//  AppManager.swift
//  Concussion Test
//
//  Created by Justin Dambra on 5/9/16.
//  Copyright © 2016 Slouch Design. All rights reserved.
//

import Foundation

class AppManager{
    
    // MARK: [Static Functions]
    static func getSportString( _ sportEnum:Int ) -> String?{
        switch sportEnum {
        case Patient.Sport.baseball.rawValue:
            return "Baseball"
        case Patient.Sport.basketball.rawValue:
            return "Basketball"
        case Patient.Sport.football.rawValue:
            return "Football"
        case Patient.Sport.hockey.rawValue:
            return "Hockey"
        case Patient.Sport.lacrosse.rawValue:
            return "Lacrosse"
        case Patient.Sport.soccer.rawValue:
            return "Soccer"
        case Patient.Sport.swimming.rawValue:
            return "Swimming"
        case Patient.Sport.tennis.rawValue:
            return "Tennis"
        case Patient.Sport.track.rawValue:
            return "Track"
        case Patient.Sport.wrestling.rawValue:
            return "Wrestling"
        default:
            return ""
        }
    }
}
