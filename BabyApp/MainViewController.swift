//
//  MainViewController.swift
//  BabyApp
//
//  Created by Jack Westcott on 10/5/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class MainViewController: UIViewController {
    
    
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var measureButton: UIButton!
    @IBOutlet var sleepButton: UIButton!
    @IBOutlet var nappyButton: UIButton!
    @IBOutlet var feedingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set border radius - looks a lot nicer
        feedingButton.layer.cornerRadius=5
        nappyButton.layer.cornerRadius=5
        sleepButton.layer.cornerRadius=5
        measureButton.layer.cornerRadius=5
        historyButton.layer.cornerRadius=5
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    // unwind segue tutorial (was covered in tut 8 but this unwind is just for going back to home - no data involved) https://medium.com/@ldeme/unwind-segues-in-swift-5-e392134c65fd
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        
    }

    

}

		
