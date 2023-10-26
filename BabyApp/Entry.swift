//
//  Entry.swift
//  BabyApp
//
//  Created by Jack Westcott on 10/5/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class Entry: Codable {
    @DocumentID var documentID:String?
    var startTime: Timestamp?
    var endTime: Timestamp?
    var date: Timestamp?
    var duration: TimeSpan?
    var notes: String?
    var feedType: String?
    var height: Float?
    var weight: Float?
    var nappyType: String?
    var category: String?
}


struct TimeSpan: Codable {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
}

