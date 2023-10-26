//
//  EditNappyViewController.swift
//  BabyApp
//
//  Created by Jack Westcott on 14/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class EditNappyViewController: UIViewController {
    
    var entry: Entry?
    var entryIndex: Int?
    
    @IBOutlet var viewImageButton: UIButton!
    @IBOutlet var notes: UITextField!
    @IBOutlet var nappyType: UISegmentedControl!
    @IBOutlet var nappyDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayEntry = entry
        {
            notes.text = displayEntry.notes
            
            
            nappyDate.date = entry?.startTime?.dateValue() ?? Date()

    
            if displayEntry.nappyType == "Wet"
            {
                nappyType.selectedSegmentIndex = 0
            }
            else if (displayEntry.nappyType == "Dirty")
            {
                nappyType.selectedSegmentIndex = 1
        
            }
            else {
                nappyType.selectedSegmentIndex = 2
            }
            
        }
       
    }
    
    @IBAction func viewImage(_ sender: Any) {
        // this has nothing in it but I think I originally had it linked to a button - saw this on
        // finishing development so I left it incase it breaks something
    }
    
    @IBAction func saveNappy(_ sender: Any) {
        
        
        let notes = notes.text ?? ""
        let nappyType = nappyType.titleForSegment(at: nappyType.selectedSegmentIndex) ?? ""
        entry!.startTime = Timestamp(date: nappyDate.date)
        entry!.notes = notes
        entry!.nappyType = nappyType
        
        
        let db = Firestore.firestore()
        
        do
        {
            //update the database (code from lectures)
            try db.collection("entries").document(entry!.documentID!).setData(from: entry!){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    self.performSegue(withIdentifier: "saveNappySegue", sender: sender)
                }
            }
        } catch { print("Error updating document \(error)") } //note "error" is a magic variable
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowImageSegue" {
            guard let displayImageController = segue.destination as? DisplayImageController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            displayImageController.entry = entry
        }
    }
    

}
