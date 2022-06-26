//
//  Response.swift
//  Campfire
//
//  Created by Jamal Benamor on 19/06/2022.
//

import Foundation
import UIKit


struct Response {
    let audio_id: String
    let uid: String
    let url: String
    let timestamp: Int
    let name: String
    
    init(audio_id: String, dictionary: [String: Any]) {
        self.audio_id = audio_id
        self.uid = dictionary["uid"] as? String ?? ""
        self.url = dictionary["url"] as? String ?? ""
        self.timestamp = dictionary["timestamp"]  as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
    }
}
