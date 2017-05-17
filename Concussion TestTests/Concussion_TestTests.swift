//
//  Concussion_TestTests.swift
//  Concussion TestTests
//
//  Created by workinman002 on 5/3/16.
//  Copyright (c) 2016 Slouch Design. All rights reserved.
//

import UIKit
import XCTest

class Concussion_TestTests: XCTestCase {
    
    // MARK: [Concussion Text Tests]
    
    // Test To Confirm The Patient Initializer Returns When No First or Last Name Or Negative Rating Is Provided
    func testMealInitialization(){
        // Success Case
        let potentialItem = Patient(firstName:"Justin", lastName:"Dambra", photo: nil, rating:5, sport:0);
        
        XCTAssertNotNil(potentialItem);
        
        // Failure Case
        let noName = Patient(firstName:"", lastName:"", photo:nil, rating:0, sport:0);
        XCTAssertNil(noName, "Empty name is invalid");
        
        let badRating = Patient(firstName:"Jack", lastName:"Frost", photo:nil, rating:-1, sport:0);
        XCTAssertNil(badRating, "Negative rating are invalid, be positive");
    }
}
