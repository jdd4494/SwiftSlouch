//
//  GlasgowComaScale.swift
//  Concussion Test
//
//  Created by Justin Dambra on 12/11/16.
//  Copyright © 2016 Slouch Design. All rights reserved.
//

import UIKit

class GlasgowComaScale: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}
