//
//  FeedingTabView.swift
//  BabyApp
//
//  Created by Jack Westcott on 10/5/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class FeedingTabView: UIViewController{

    
    @IBOutlet var timerDisplay: UILabel!
    @IBOutlet var pickSideControl: UISegmentedControl!
    @IBOutlet var feedNotes: UITextField!
    @IBOutlet var resetRecording: UIButton!
    @IBOutlet var startRecording: UIButton!
    @IBOutlet var saveFeed: UIButton!
    
    var isRecording = false
    var timer = Timer()
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default to -1 so when user goes in there is no option selected
        saveFeed.isEnabled = false
        startRecording.isEnabled = false
        pickSideControl.selectedSegmentIndex = -1
      
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex != -1) {
            startRecording.isEnabled = true
            saveFeed.isEnabled = true
            
        }
        // if user selects bottle, disable timer so it kind of hints that we dont want recorded times for a bottle feed
        // didnt do this on my android app but I think it makes more sense
        if (sender.selectedSegmentIndex == 2) {
            startRecording.isEnabled = false
            timer.invalidate()
            isRecording = false
            seconds = 0
            timerDisplay.text = "00:00:00"
            startRecording.setTitle("Start", for: .normal)
        }
    }
    
    
    
    
    // timer code help - https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer and https://codewithchris.com/swift-timer/
    @IBAction func resetRecording(_ sender: Any) {
        timer.invalidate()
        seconds = 0
        isRecording = false
        timerDisplay.text = "00:00:00"
        startRecording.setTitle("Start", for: .normal)
    }
    @IBAction func startRecord(_ sender: UIButton) {
        if isRecording {
            timer.invalidate()
            isRecording = false
            startRecording.setTitle("Start", for: .normal)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isRecording = true
            startRecording.setTitle("Pause", for: .normal)
            
        }
    }
        @objc func updateTimer() {
            seconds += 1
            
            // pretty much the same as in kotlin - use modulo so the number changes over after 60 secs
            let hrs = seconds / 3600
            let mins = seconds / 60 % 60
            let secs = seconds % 60
            timerDisplay.text = String(format: "%02d:%02d:%02d", hrs, mins, secs)
        }

    
    
    @IBAction func saveFeed(_ sender: Any) {
        timer.invalidate() //
        
        let duration = TimeSpan(hours: seconds/3600, minutes: (seconds % 3600) / 60, seconds: seconds % 60)
        let startTime = Timestamp(date: Date())
        let notes = feedNotes.text ?? ""
        let feedingType = pickSideControl.titleForSegment(at: pickSideControl.selectedSegmentIndex) ?? ""

        let entry = Entry()
        entry.duration = duration
        entry.startTime = startTime
        entry.notes = notes
        entry.feedType = feedingType
        entry.category = "feed"
        
        let db = Firestore.firestore()
        
        // all add to database code is from the tutorial, just modified it for this app
        do {
            
            let entryRef = db.collection("entries").document()
            entry.documentID = entryRef.documentID
            try entryRef.setData(from: entry)
            if let entryID = entry.documentID {
                print("Entry saved successfully with ID: \(entryID)")
                performSegue(withIdentifier: "feedingUnwind", sender: self)
            } else {
                print("Entry saved successfully without an ID")
            }
                        
        } catch let error {
            print("Error saving entry: \(error.localizedDescription)")
        }
            
    }
}

/*
do
{
    //update the database (code from lectures)
    try db.collection("movies").document(movie!.documentID!).setData(from: movie!){ err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("Document successfully updated")
            //this code triggers the unwind segue manually
            self.performSegue(withIdentifier: "saveSegue", sender: sender)
        }
    }
} catch { print("Error updating document \(error)") } //note "error" is a magic variable
}
 */
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


