//
//  MeasurementsTabView.swift
//  BabyApp
//
//  Created by Jack Westcott on 10/5/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class MeasurementsTabView: UIViewController {

    @IBOutlet var weightSlider: UISlider!
    @IBOutlet var heightSlider: UISlider!
    @IBOutlet var measurementNotes: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var height: UITextField!
    @IBOutlet var dateOfMeasurement: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        // Do any additional setup after loading the view.
    }
    
    
    // couldnt figure out how to make this work in "real time" i.e., the slider will only change if I click away from the textfield - https://www.cyanhall.com/how-to/iOS/4.make-UISlider-value-changed-by-step/
    @IBAction func textHeightChange(_ sender: Any) {
        if let heightVal = Float(height.text ?? "") {
            heightSlider.value = heightVal
        }
    }
   
    @IBAction func sliderChangeHeight(_ sender: Any) {
        height.text = String(round(heightSlider.value))
    }
    
    @IBAction func sliderChangeWeight(_ sender: Any) {
        weight.text = String(round(weightSlider.value))
    }
    
    @IBAction func textWeightChange(_ sender: Any) {
        if let weightVal = Float(weight.text ?? "") {
            weightSlider.value = weightVal
        }
    }
    @IBAction func saveMeasurement(_ sender: Any) {
            
        let date = dateOfMeasurement.date
        
        // format the date
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = formatDate.string(from: date)
        let notes = measurementNotes.text ?? ""

        let entry = Entry()
        entry.notes = notes
        entry.category = "measurement"
        
        
        let db = Firestore.firestore()
        
        
        
        if let heightText = height.text,
           let dbHeight = Float(heightText),
           let weightText = weight.text,
           let dbWeight = Float(weightText),
           let newDate = formatDate.date(from: formattedDate)
        {
            entry.height = dbHeight
            entry.weight = dbWeight
            entry.startTime = Timestamp(date: newDate)
                            
            do {
                let entryRef = db.collection("entries").document()
                entry.documentID = entryRef.documentID
                try entryRef.setData(from: entry)
                if let entryID = entry.documentID {
                    print("Entry saved successfully with ID: \(entryID)")
                    performSegue(withIdentifier: "measureUnwind", sender: self)
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
