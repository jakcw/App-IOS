//
//  EditFeedViewController.swift
//  BabyApp
//
//  Created by Jack Westcott on 13/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class EditFeedViewController: UIViewController {
    var entry: Entry?
    var entryIndex: Int?
    
    
    @IBOutlet var notesEdit: UITextField!
    @IBOutlet var sideEdit: UISegmentedControl!
    @IBOutlet var secsEdit: UITextField!
    @IBOutlet var minsEdit: UITextField!
    @IBOutlet var hrsEdit: UITextField!
    @IBOutlet var feedDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let displayEntry = entry
        {
            notesEdit.text = displayEntry.notes
            
            feedDate.date = entry?.startTime?.dateValue() ?? Date()

            if let secs = entry?.duration?.seconds,
                let mins = entry?.duration?.minutes,
                let hrs = entry?.duration?.hours
            {
                secsEdit.text = String(secs)
                minsEdit.text = String(mins)
                hrsEdit.text = String(hrs)
            }
            
            if displayEntry.feedType == "Bottle"
            {
                sideEdit.selectedSegmentIndex = 2
            }
            else if (displayEntry.feedType == "Left")
            {
                sideEdit.selectedSegmentIndex = 0
        
            }
            else {
                sideEdit.selectedSegmentIndex = 1
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveFeed(_ sender: Any) {
                
       
        
        let notes = notesEdit.text ?? ""
        let feedingType = sideEdit.titleForSegment(at: sideEdit.selectedSegmentIndex) ?? ""
        entry!.startTime = Timestamp(date: feedDate.date)
        entry!.notes = notes
        entry!.feedType = feedingType
        
        let hours = Int(hrsEdit.text ?? "0") ?? 0
        let minutes = Int(minsEdit.text ?? "0") ?? 0
        let seconds = Int(secsEdit.text ?? "0") ?? 0
        
        entry!.duration?.hours = hours
        entry!.duration?.minutes = minutes
        entry!.duration?.seconds = seconds
        
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
                    self.performSegue(withIdentifier: "saveFeedSegue", sender: sender)
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
