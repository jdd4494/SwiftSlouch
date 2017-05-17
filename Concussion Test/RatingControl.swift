//
//  RatingControl.swift
//  Concussion Test
//
//  Created by Justin Dambra on 5/4/16.
//  Copyright © 2016 Slouch Design. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    // MARK: [Properties]
    var rating = 0{
        didSet{
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]();
    let spacing = 5;
    let starCount = 5;
    
    // MARK: [Initialization]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        let filledStarImage = UIImage(named: "filledStar");
        let emptyStarImage = UIImage(named: "emptyStar");
        
        for _ in 0..<starCount{
            let button = UIButton();
            // button.backgroundColor = UIColor.redColor();
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown);
            
            button.setImage(emptyStarImage, for: UIControlState());
            button.setImage(filledStarImage, for: .selected);
            button.setImage(filledStarImage, for: [.highlighted, .selected]);
            button.adjustsImageWhenHighlighted = false;
            
            ratingButtons += [button];
            addSubview(button);
        }
    }
    
    override func layoutSubviews() {
       let buttonSize = Int(frame.size.height);
        
        var buttonFrame = CGRect(x:0,y:0,width: buttonSize, height: buttonSize);
        
        // Offset each button's origin by the length of the button spacing
        for(index, button) in ratingButtons.enumerated(){
            buttonFrame.origin.x = CGFloat(index*(buttonSize+spacing));
            button.frame = buttonFrame;
        }
        
        updateButtonSelectionStates();
    }
    
    override var intrinsicContentSize : CGSize {
        let buttonSize = Int(frame.size.height);
        let width = (buttonSize * starCount) + (spacing * (starCount - 1));
        
        return CGSize(width: width, height: buttonSize);
    }
    
    // MARK: [Action]
    func ratingButtonTapped(_ button:UIButton){
        rating = ratingButtons.index(of: button)! + 1;
        
        updateButtonSelectionStates();
    }
    
    func updateButtonSelectionStates(){
        for(index, button) in ratingButtons.enumerated(){
            // If the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating;
        }
    }
}
