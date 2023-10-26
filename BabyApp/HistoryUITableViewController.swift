//
//  HistoryUITableViewController.swift
//  BabyApp
//
//  Created by Jack Westcott on 12/5/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HistoryUITableViewController: UITableViewController {
    
    var entries = [Entry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let db = Firestore.firestore()
        let entryCollection = db.collection("entries")
        
        // chronological start times, same as android app
        entryCollection.order(by: "startTime", descending: true).getDocuments(){ (result, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
                
            }
            else
            {
                for document in result!.documents
                {
                    let conversionResult = Result
                    {
                        try document.data(as: Entry.self)
                    }
                    switch conversionResult
                    {
                    case .success(let entry):
                        print("Entry: \(entry)")
                        self.entries.append(entry)
                        
                    case .failure(let error):
                        print("Error decoding entry: \(error)")
                        
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // from tutorial 8 
    @IBAction func unwindToEntryList(sender: UIStoryboardSegue)
    {
        if let entryScreen = sender.source as? EditFeedViewController
        {
            entries[entryScreen.entryIndex!] = entryScreen.entry!
            tableView.reloadData()
        }
        else if let entryScreen = sender.source as? EditNappyViewController
        {
            entries[entryScreen.entryIndex!] = entryScreen.entry!
            tableView.reloadData()
        }
        else if let entryScreen = sender.source as? EditSleepViewController
        {
            entries[entryScreen.entryIndex!] = entryScreen.entry!
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // just for debugging
        print("NUM_ENTRIES: ", entries.count)
        
        return entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let entry = entries[indexPath.row]
        print("PATH", indexPath.row)
        let category = entry.category
        
        // used the same approach as with my android app - not sure if this is best practise but it seems to work. The function tableView requires a return type of UITableView so if any cells dont load then it will just load the default cell. This documentation segment helped as well - https://developer.apple.com/documentation/uikit/views_and_controls/table_views/configuring_the_cells_for_your_table
        
        switch category {
        case "nappy":
            if let nappyCell = tableView.dequeueReusableCell(withIdentifier: "NappyTableViewCell", for: indexPath) as? NappyTableViewCell {
                if let nappyType = entry.nappyType {
                    nappyCell.entryType.text = "Nappy, " + String(nappyType)
                } else {
                    nappyCell.entryType.text = "Nappy"
                }
                
                nappyCell.notes.text = entry.notes

                if let timestamp = entry.startTime {
                    let seconds = timestamp.seconds
                    
                    
                    // firebase timestamp to swift date - https://stackoverflow.com/questions/51116381/convert-firebase-firestore-timestamp-to-date-swift
                    let date = Date(timeIntervalSince1970: TimeInterval(seconds))
                    
                    // date styles - https://stackoverflow.com/questions/24100855/set-a-datestyle-in-swift
                    let dateFormatter = DateFormatter()
                    
                    // sets the date type
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    
                    let dateString = dateFormatter.string(from: date)
                    
                    nappyCell.dateTime.text = dateString
                } else {
                    // Handle the case where timestamp is nil
                    nappyCell.dateTime.text = "No date"
                }
                return nappyCell;
            } else {
                return UITableViewCell()
            }
            
        case "sleep":
            if let sleepCell = tableView.dequeueReusableCell(withIdentifier: "SleepTableViewCell", for: indexPath) as? SleepTableViewCell {
                sleepCell.notes.text = entry.notes
                
                if let timestampStart = entry.startTime,
                   let timestampEnd = entry.endTime {
                    let secondsStart = timestampStart.seconds
                    let secondsEnd = timestampEnd.seconds
                    
                    // firebase timestamp to swift date - https://stackoverflow.com/questions/51116381/convert-firebase-firestore-timestamp-to-date-swift
                    let dateStart = Date(timeIntervalSince1970: TimeInterval(secondsStart))
                    let dateEnd = Date(timeIntervalSince1970: TimeInterval(secondsEnd))
                    
                    // duration between two time intervals - https://stackoverflow.com/questions/47967135/get-time-difference-between-two-times-in-swift-3
                    let sleepDuration = dateEnd.timeIntervalSince1970 - dateStart.timeIntervalSince1970
                    let hrs = Int(sleepDuration / 3600)
                    let mins = Int(sleepDuration / 60) % 60
                    
                    
            
                    let sleepDur: String
                    if hrs > 0 {
                        if mins >= 10 {
                            sleepDur = String(format: "Slept for %01d hours and %02d mins", hrs, mins)
                        } else {
                            sleepDur = String(format: "Slept for %01d hours and %01d mins", hrs, mins)
                        }
                    } else if mins > 0 {
                        if mins >= 10 {
                            sleepDur = String(format: "Slept for %02d mins", mins)
                        } else {
                            sleepDur = String(format: "Slept for %01d mins", mins)
                        }
                    } else {
                        sleepDur = "Did not sleep"
                    }
                    sleepCell.duration.text = sleepDur
                    // date styles - https://stackoverflow.com/questions/24100855/set-a-datestyle-in-swift
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yy, h:mma"

                    let dateString = dateFormatter.string(from: dateStart)

                    sleepCell.category.text = "Fell asleep on " + dateString

                    
                    
                } else {
                    // Handle the case where timestamp is nil
                    sleepCell.category.text = "Sleep"
                    
                }
                
                
                return sleepCell;
                
            } else {
                return UITableViewCell()
            }
            
        case "measurement":
            if let measureCell = tableView.dequeueReusableCell(withIdentifier: "MeasurementTableViewCell", for: indexPath) as? MeasurementTableViewCell {
                if let timestamp = entry.startTime {
                    
                    let seconds = timestamp.seconds
                    let date = Date(timeIntervalSince1970: TimeInterval(seconds))
                    let dateFormatter = DateFormatter()
                    
                    // sets the date type
                    dateFormatter.dateStyle = .medium
                    
                    let dateString = dateFormatter.string(from: date)
                    
                    measureCell.measureDate.text = dateString
                } else {
                    // Handle the case where timestamp is nil
                    measureCell.measureDate.text = "No date"
                }
                if let height = entry.height,
                   let weight = entry.weight {
                    measureCell.measurements.text = "Height: " + String(height) + "cm, Weight: " + String(weight) + "kg"
                } else {
                    measureCell.measurements.text = "No measurements found"
                }
                
                measureCell.notes.text = entry.notes;
                
                return measureCell;
            } else {
                return UITableViewCell()
            }
            
        case "feed":
            if let feedCell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell {
                if let timestamp = entry.startTime,
                   let duration = entry.duration {
                    
                    // I dont think babies ever feed on the scale of hours but oh well
                    let durationHrs = duration.hours
                    let durationMins = duration.minutes
                    let durationSecs = duration.seconds
                    
                    
            
                    // very janky but it works - didnt do this with my android app but say we have mins 20 and hour 0, secs 10 then it will only show the mins and hours. Same for the other duration values
                    if let feedType = entry.feedType {
                        if feedType == "Bottle" {
                            feedCell.feedType.text = "Fed with bottle"
                        } else {
                            if durationHrs > 0 && durationMins > 0 && durationSecs > 0 {
                                feedCell.feedType.text = "Fed on " + feedType + " side: " + String(durationHrs) + " hrs, " + String(durationMins) + " mins, " + String(durationSecs) + " secs"
                            } else if durationHrs > 0 && durationMins == 0 && durationSecs > 0 {
                                feedCell.feedType.text = "Fed on " + feedType + " side: " + String(durationHrs) + " hrs, " + String(durationSecs) + " secs"
                            } else if durationHrs == 0 && durationMins > 0 && durationSecs > 0 {
                                feedCell.feedType.text = "Fed on " + feedType + " side: " + String(durationMins) + " mins, " + String(durationSecs) + " secs"
                            } else if durationHrs == 0 && durationMins > 0 && durationSecs == 0 {
                                feedCell.feedType.text = "Fed on " + feedType + " side: " + String(durationMins) + " mins"
                            } else if durationHrs == 0 && durationMins == 0 && durationSecs > 0 {
                                feedCell.feedType.text = "Fed on " + feedType + " side: " + String(durationSecs) + " secs"
                            } else {
                                feedCell.feedType.text = "Fed on " + feedType + " side: no duration found"
                            }
                        }
                    } else {
                        feedCell.feedType.text = "No feed type found"
                    }
                 
                    
                    let seconds = timestamp.seconds
                    let date = Date(timeIntervalSince1970: TimeInterval(seconds))
                    let dateFormatter = DateFormatter()
                    
                    // sets the date type
                    dateFormatter.dateStyle = .medium
                    
                    let dateString = dateFormatter.string(from: date)
                    
                    feedCell.feedDate.text = "Feed on " + dateString
                
                } else {
                    feedCell.feedDate.text =  "No duration or date found"
        
                }
                
                feedCell.notes.text = entry.notes;
                
                
                
                
                return feedCell;
            } else {
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    // youtube tutorial for delete functionality - https://www.youtube.com/watch?v=MC4mDQ7UqEE
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    
    // Override to support editing the table view.
    // delete table view cell as well as firestore entry - https://stackoverflow.com/questions/73022998/how-to-delete-files-from-firebase-storage-and-table-view-swift
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let db = Firestore.firestore()
            if let entryID = entries[indexPath.row].documentID {
                let entry = db.collection("entries").document(entryID)
                                entry.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        
                        self.entries.remove(at: indexPath.row)
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }
                }
            }
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         super.prepare(for: segue, sender: sender)
         
         if segue.identifier == "ShowEditFeedSegue"
         {
             guard let editFeedViewController = segue.destination as? EditFeedViewController else
             {
                 fatalError("Unexpected destination: \(segue.destination)")
             }
             guard let selectedFeedCell = sender as? FeedTableViewCell else
             {
                 fatalError()
             }
             guard let indexPath = tableView.indexPath(for: selectedFeedCell) else {
                 fatalError()
             }
             
             let selectedFeed = entries[indexPath.row]
             editFeedViewController.entry = selectedFeed
             editFeedViewController.entryIndex = indexPath.row
         }
         else if segue.identifier == "ShowEditNappySegue"
         {
             guard let editNappyViewController = segue.destination as? EditNappyViewController else
             {
                 fatalError("Unexpected destination: \(segue.destination)")
             }
             guard let selectedNappyCell = sender as? NappyTableViewCell else
             {
                 fatalError()
             }
             guard let indexPath = tableView.indexPath(for: selectedNappyCell) else {
                 fatalError()
             }
             
             let selectedNappy = entries[indexPath.row]
             editNappyViewController.entry = selectedNappy
             editNappyViewController.entryIndex = indexPath.row
         }
         else if segue.identifier == "ShowEditSleepSegue"
         {
             guard let editSleepViewController = segue.destination as? EditSleepViewController else
             {
                 fatalError("Unexpected destination: \(segue.destination)")
             }
             guard let selectedSleepCell = sender as? SleepTableViewCell else
             {
                 fatalError()
             }
             guard let indexPath = tableView.indexPath(for: selectedSleepCell) else {
                 fatalError()
             }
             
             let selectedSleep = entries[indexPath.row]
             editSleepViewController.entry = selectedSleep
             editSleepViewController.entryIndex = indexPath.row
         }
         
         
     }
     
    
}
