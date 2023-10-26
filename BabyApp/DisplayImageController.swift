//
//  DisplayImageController.swift
//  BabyApp
//
//  Created by Jack Westcott on 16/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class DisplayImageController: UIViewController {
    
    
    // using same method as tutorial 8 - entry ID sent from the edit screen to the popup - same as sending from history to edit screen
    var entry: Entry?
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
      
        // this loads the image pretty slowly - I am sure it could be sped up but but I couldn't figure out how - https://stackoverflow.com/questions/66366111/download-image-from-firebase-storage-in-swift
        // documentation - https://firebase.google.com/docs/storage/ios/download-files

        if let imageEntry = entry {
            if let entryID = imageEntry.documentID {
                let imageInDB = storageRef.child("entries/" + entryID + ".jpg")
                
                imageInDB.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Failed to load image \(error)")
                    } else {
                        let image = UIImage(data: data!)
                        self.imageView.image = image
                        self.imageView.contentMode = .scaleAspectFill
                        self.imageView.clipsToBounds = true
                        self.imageView.layer.borderWidth = 2
                        self.imageView.layer.cornerRadius = 5
                        self.imageView.layer.borderColor = UIColor.black.cgColor
                    }
                }
            }
            
        }
        
      
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
