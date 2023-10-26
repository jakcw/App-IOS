//
//  NappyTabView.swift
//  BabyApp
//
//  Created by Jack Westcott on 10/5/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
class NappyTabView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    // instead of storing in imageview (dont want the photo displayed in add nappy screen) I am going to store in a UIImage variable so it can be uploaded to firebase
    var selectedPic: UIImage?
    @IBOutlet var nappyNotes: UITextField!
    @IBOutlet var nappyType: UISegmentedControl!
    @IBOutlet var saveNappy: UIButton!
    @IBOutlet var nappyDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        saveNappy.isEnabled = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    
    }
    
    
    
    @IBAction func onChange(_ sender: Any) {
        if nappyType.selectedSegmentIndex != -1 {
            saveNappy.isEnabled = true
        }
    }
    
    
    // most of this is from the camera code you (Lindsay) put on github
    @IBAction func cameraButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("DEBUGGING: Gallery available")
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
   
    
    // adapted from the commented out code in your camera code
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           {
               self.selectedPic = image
               dismiss(animated: true, completion: nil)
           }
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
   
    
    
    @IBAction func saveNappy(_ sender: Any) {
        let dateTime = nappyDate.date
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy HH:mm"
        let combinedDateTimeString = formatDate.string(from: dateTime)
        let notes = nappyNotes.text ?? ""
        let nappyType = nappyType.titleForSegment(at: nappyType.selectedSegmentIndex) ?? ""

        let entry = Entry()
        
        entry.notes = notes
        entry.nappyType = nappyType
        entry.category = "nappy"
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
      
        if let combinedDateTime = formatDate.date(from: combinedDateTimeString) {
            let timestamp = Timestamp(date: combinedDateTime)
            entry.startTime = timestamp
            
            do {
                
                let entryRef = db.collection("entries").document()
                entry.documentID = entryRef.documentID
                try entryRef.setData(from: entry)
                if let entryID = entry.documentID {
                    let storageRef = storage.reference().child("entries/" + entryID + ".jpg")
                    print("Entry saved successfully with ID: \(entryID)")
                    
                    // images are optional so if there is one selected we will upload to fbstorage with same same document id - same as with the android app - got help from the documentation - https://firebase.google.com/docs/storage/ios/upload-files and https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
                
                    if let imageChosen = self.selectedPic {
                        if let imageData = imageChosen.jpegData(compressionQuality: 0.1) {
                            storageRef.putData(imageData, metadata:nil)
                        }
                        
                    }
                    
                    performSegue(withIdentifier: "nappyUnwind", sender: self)
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
