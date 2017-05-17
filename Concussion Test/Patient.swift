//
//  Patient.swift
//  Concussion Test
//
//  Created by Justin Dambra on 5/5/16.
//  Copyright © 2016 Slouch Design. All rights reserved.
//

import UIKit

class Patient:NSObject, NSCoding{
    
    // MARK: [Properties]
    var firstName:String;
    var lastName:String;
    var photo:UIImage?;
    var rating:Int;
    var sport:Sport;
    
    struct PropertyKey {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let photoKey = "photo"
        static let ratingKey = "rating"
        static let sportKey = "sport"
        static let rowKey = "row"
    }
    
    enum Sport:Int {
        case baseball = 0
        case basketball = 1
        case football = 2
        case hockey = 3
        case lacrosse = 4
        case soccer = 5
        case swimming = 6
        case tennis = 7
        case track = 8
        case wrestling = 9
    }
    
    // MARK: [Archiving Paths]
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("patients");
    
    // MARK: [Initialization]
    init?(firstName:String, lastName:String, photo:UIImage?, rating:Int, sport:Int){
        self.firstName = firstName;
        self.lastName = lastName;
        self.photo = photo;
        self.rating = rating;
        self.sport = Sport(rawValue:sport)!;
        
        super.init();
        
        if(firstName.isEmpty || lastName.isEmpty || rating < 0){
            return nil;
        }
    }
    
    // MARK: [TableView Methods]

    
    // MARK: [NSCoding]
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: PropertyKey.firstNameKey);
        aCoder.encode(lastName, forKey: PropertyKey.lastNameKey);
        aCoder.encode(photo, forKey: PropertyKey.photoKey);
        aCoder.encode(rating, forKey: PropertyKey.ratingKey);
        aCoder.encode(sport.rawValue, forKey: PropertyKey.sportKey);
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObject(forKey: PropertyKey.firstNameKey) as! String;
        let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastNameKey) as! String;
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photoKey) as? UIImage;
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.ratingKey);
        let sport = aDecoder.decodeInteger(forKey: PropertyKey.sportKey);
        // let row = aDecoder.decodeInteger(forKey: PropertyKey.rowKey);
        
        self.init(firstName:firstName, lastName: lastName, photo: photo, rating: rating, sport:sport);
    }
}
