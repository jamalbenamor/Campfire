//
//  Profile.swift
//  Campfire
//
//  Created by Jamal Benamor on 2022/6/27.
//

 
import Foundation
import CoreData
import UIKit

struct Profile: Codable, Hashable {
    
    var uid: String
    var name: String
    var username: String
    var phone_number: String
    var last_online: Int
    var date_joined: Int
    var suspended: Bool
    
    var profile_image_url: String?
    var last_posted: String?
    var last_recording: String?
    
    var todays_question: String
    var posted_today: Bool
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case username
        case phone_number
        case last_online
        case date_joined
        case suspended
        case profile_image_url
        case last_posted
        case last_recording
        case todays_question
        case posted_today
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.uid == rhs.uid &&
            lhs.name == rhs.name &&
            lhs.username == rhs.username &&
            lhs.phone_number == rhs.phone_number &&
            lhs.last_online == rhs.last_online &&
            lhs.date_joined == rhs.date_joined &&
            lhs.suspended == rhs.suspended &&
            lhs.profile_image_url == rhs.profile_image_url &&
            lhs.last_posted == rhs.last_posted &&
            lhs.last_recording == rhs.last_recording &&
            lhs.todays_question == rhs.todays_question &&
            lhs.posted_today == rhs.posted_today
    }
    
}


extension Profile {
     
    static var profile1: Profile = Profile(uid: "", name: "", username: "", phone_number: "", last_online: 0, date_joined: 0, suspended: false, profile_image_url: nil, last_posted: nil, last_recording: nil, todays_question: "", posted_today: true)
    
    
    static var profile: Profile = {
        
        print("fetch  profile from core data")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print("fetch  profile from core data")
//        deleteRecords()
        // fetch friends
        print("fetch  profile from core data")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyProfile")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        var profile: Profile = Profile(uid: "", name: "", username: "", phone_number: "", last_online: 0, date_joined: 0, suspended: false, profile_image_url: nil, last_posted: nil, last_recording: nil, todays_question: "", posted_today: true)
        print("fetch  profile from core data")
        do {
            let result = try context.fetch(request)
            print("result: ", result)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "uid") as! String)
                
                
                profile = Profile(uid: data.value(forKey: "uid") as! String,
                                  name: data.value(forKey: "name") as! String,
                                  username: data.value(forKey: "username") as! String,
                                  phone_number: data.value(forKey: "phone_number") as! String,
                                  last_online: data.value(forKey: "last_online") as! Int,
                                  date_joined: data.value(forKey: "date_joined") as! Int,
                                  suspended: data.value(forKey: "suspended") as! Bool,
                                  profile_image_url: data.value(forKey: "profile_image_url") as? String,
                                  last_posted: data.value(forKey: "last_posted") as? String,
                                  last_recording: data.value(forKey: "last_recording") as? String,
                                  todays_question: data.value(forKey: "todays_question") as! String,
                                  posted_today: data.value(forKey: "posted_today") as! Bool)
            }
            return profile
             
        } catch {
            print("Failed")
        }
        
        return profile
    }()
    
    static func savePosts() {
        
        
    }
    
    static func refreshProfile() {
        
        // reset core data and update to profile

        // reset core data
        deleteRecords()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // save from json to core data
        let entity = NSEntityDescription.entity(forEntityName: "MyProfile", in: context)

        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(profile.uid, forKey: "uid")
        newUser.setValue(profile.name, forKey: "name")
        newUser.setValue(profile.username, forKey: "username")
        newUser.setValue(profile.phone_number, forKey: "phone_number")
        newUser.setValue(profile.last_online, forKey: "last_online")
        newUser.setValue(profile.date_joined, forKey: "date_joined")
        newUser.setValue(profile.suspended, forKey: "suspended")
        newUser.setValue(profile.profile_image_url, forKey: "profile_image_url")
        newUser.setValue(profile.last_posted, forKey: "last_posted")
        newUser.setValue(profile.last_recording, forKey: "last_recording")
        newUser.setValue(profile.todays_question, forKey: "todays_question")
        newUser.setValue(profile.posted_today, forKey: "posted_today")

        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
     
    static func deleteRecords() {
        print("deleteRecords profile")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MyProfile")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}


