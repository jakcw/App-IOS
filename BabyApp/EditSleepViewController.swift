//
//  EditSleepViewController.swift
//  BabyApp
//
//  Created by Jack Westcott on 13/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class EditSleepViewController: UIViewController {
    var entry: Entry?
    var entryIndex: Int?
    
    @IBOutlet var notes: UITextField!
    @IBOutlet var endTime: UIDatePicker!
    @IBOutlet var startTime: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayEntry = entry
        {
            notes.text = displayEntry.notes
            
            startTime.date = entry?.startTime?.dateValue() ?? Date()
            endTime.date = entry?.endTime?.dateValue() ?? Date()
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveSleep(_ sender: Any) {
        let notes = notes.text ?? ""
        
        entry!.startTime = Timestamp(date: startTime.date)
        entry!.endTime = Timestamp(date: endTime.date)
        entry!.notes = notes
        
        
        let db = Firestore.firestore()
        
        do
        {
            //update the database (code from lectures)
            try db.collection("entries").document(entry!.documentID!).setData(from: entry!){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    //this code triggers the unwind segue manually
                    self.performSegue(withIdentifier: "saveSleepSegue", sender: sender)
                }
            }
        } catch { print("Error updating document \(error)") } //note "error" is a magic variable
        
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
