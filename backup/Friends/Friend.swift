//
//  Friend.swift
//  FriendsGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import Foundation
import CoreData
import UIKit

struct Friend: Codable, Hashable {
    
    let uid: String
    let name: String
    let username: String
    let phone_number: String?
    let profile_image_url: String?
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case username
        case phone_number
        case profile_image_url
        case category
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.uid == rhs.uid &&
            lhs.name == rhs.name &&
            lhs.username == rhs.username &&
            lhs.phone_number == rhs.phone_number &&
            lhs.profile_image_url == rhs.profile_image_url &&
            lhs.category == rhs.category
    }
    
}


extension Friend {
    
    static var friends: [Friend] = {
        
        print("fetch friends from core data")
         
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
         
        // fetch friends
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friends")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        var friends: [Friend] = []
        
        do {
            let result = try context.fetch(request)
//            print("result: ", result)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                friends.insert(Friend(uid: data.value(forKey: "uid") as! String, name: data.value(forKey: "name") as! String, username: data.value(forKey: "username") as! String, phone_number: data.value(forKey: "phone_number") as? String, profile_image_url: data.value(forKey: "profile_image_url") as? String, category: data.value(forKey: "category") as! String), at: 0)
            }
            return friends
             
        } catch {
            print("Failed")
        }
        
        return friends
//        return items
    }()
    
    static func saveFriends() {
        
        
    }
    
    static func refreshFriends() {
        
        print("reset core data from users array")
//        guard let items: [Friend] = try? Bundle.main.loadAndDecodeJSON(filename: "ff7r", keyDecodingStrategy: .convertFromSnakeCase) else {
//            return
//        }
        
        let items = friends

        // reset core data
        deleteRecords()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // save from json to core data
        let entity = NSEntityDescription.entity(forEntityName: "Friends", in: context)

        for item in items {
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(item.uid, forKey: "uid")
            newUser.setValue(item.name, forKey: "name")
            newUser.setValue(item.username, forKey: "username")
            newUser.setValue(item.phone_number, forKey: "phone_number")
            newUser.setValue(item.profile_image_url, forKey: "profile_image_url")
            newUser.setValue(item.category, forKey: "category")
        }

        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    static var friends1: [Friend] = [
        Friend(uid: "78324n87fn183dsds", name: "Jamal", username: "jamal", phone_number: "+447966793804", profile_image_url: nil, category: "friends"),
        Friend(uid: "787we324sdn87fn3dsds", name: "James", username: "james", phone_number: "+447966793801", profile_image_url: nil, category: "suggestions"),
        Friend(uid: "787324n87fsdn18sadsds", name: "Lucas", username: "lucas", phone_number: "+447966793834", profile_image_url: nil, category: "friends"),
        Friend(uid: "787we324sd87fn3dsds", name: "Freddie", username: "freddie3", phone_number: "+447566793801", profile_image_url: nil, category: "received_friend_requests"),
        Friend(uid: "78732n87fsdn18sa3dsds", name: "India", username: "india", phone_number: "+447966793824", profile_image_url: nil, category: "sent_friend_requests")]
        
    
    static var searchedUsers: [Friend] = [
        Friend(uid: "787324n78dsds", name: "Jack2", username: "jack2", phone_number: "+447967793804", profile_image_url: nil, category: "search")]
    
    static func findUserPos(uid: String, array: [Friend]) -> Int? {
        var n = 0
        for char in array {
            if char.uid == uid {
                return n
            }
            n += 1
        }
        return nil
    }
    
    static func deleteRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Friends")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}


