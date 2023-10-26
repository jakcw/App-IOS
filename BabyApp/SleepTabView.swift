//
//  SleepTabView.swift
//  BabyApp
//
//  Created by Jack Westcott on 10/5/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class SleepTabView: UIViewController {
    
    @IBOutlet var startTime: UIDatePicker!
    @IBOutlet var endTime: UIDatePicker!
    @IBOutlet var sleepNotes: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        // Do any additional setup after loading the view.
    }
    
    // add nappy and sleep pretty much the same - obviously end time added for adding sleep
    @IBAction func saveSleep(_ sender: Any) {
        
        // get datetimes from both pickers
        let dateTimeStart = startTime.date
        let dateTimeEnd = endTime.date
        
        // format the date
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy HH:mm"
        
        let combineStart = formatDate.string(from: dateTimeStart)
        let combineEnd = formatDate.string(from: dateTimeEnd)
        
        
        let notes = sleepNotes.text ?? ""

        let entry = Entry()
        
        entry.notes = notes
        entry.category = "sleep"
        
        let db = Firestore.firestore()
        
        
        if let combinedDTStart = formatDate.date(from: combineStart),
           let combinedDTEnd = formatDate.date(from: combineEnd)
        {
            entry.startTime = Timestamp(date: combinedDTStart)
            entry.endTime = Timestamp(date: combinedDTEnd)
                        
            do {
                
                let entryRef = db.collection("entries").document()
                entry.documentID = entryRef.documentID
                try entryRef.setData(from: entry)
                if let entryID = entry.documentID {
                    print("Entry saved successfully with ID: \(entryID)")
                    performSegue(withIdentifier: "sleepUnwind", sender: self)
                } else {
                    print("Entry saved successfully without an ID")
                }
                            
            } catch let error {
                print("Error saving entry: \(error.localizedDescription)")
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
