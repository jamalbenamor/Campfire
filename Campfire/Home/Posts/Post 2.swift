//
//  Post.swift
//  Campfire
//
//  Created by Jamal Benamor on 2022/6/27.
//
 

import Foundation
import CoreData
import UIKit

struct Post: Codable, Hashable {
    
    let uid: String
    let name: String
    let username: String
    let recording_url: String
    let recording_date: String
    let responses: Int
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case username
        case recording_url
        case recording_date
        case responses
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.uid == rhs.uid &&
            lhs.name == rhs.name &&
            lhs.username == rhs.username &&
            lhs.recording_url == rhs.recording_url &&
            lhs.recording_date == rhs.recording_date &&
            lhs.responses == rhs.responses
    }
    
}


extension Post {
    
    static var tempPosts: [Post] = []
    
    static var posts: [Post] = {
//        deletePosts()
        print("fetch posts from core data")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
         
        // fetch friends
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Posts")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        var posts: [Post] = []
        
        do {
            let result = try context.fetch(request)
//            print("result: ", result)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "uid") as! String)
                posts.insert(Post(uid: data.value(forKey: "uid") as! String, name: data.value(forKey: "name") as! String, username: data.value(forKey: "username") as! String, recording_url: data.value(forKey: "recording_url") as! String, recording_date: data.value(forKey: "recording_date") as! String, responses: data.value(forKey: "responses") as! Int), at: 0)
            }
            return posts
             
        } catch {
            print("Failed")
        }
        
        return posts
    }()
    
    static func savePosts() {
        
        
    }
    
    static func refreshPosts() {
        
        // reset core data and update to posts array

        // reset core data
        deletePosts()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // save from json to core data
        let entity = NSEntityDescription.entity(forEntityName: "Posts", in: context)

        for item in posts {
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(item.uid, forKey: "uid")
            newUser.setValue(item.name, forKey: "name")
            newUser.setValue(item.username, forKey: "username")
            newUser.setValue(item.recording_url, forKey: "recording_url")
            newUser.setValue(item.recording_date, forKey: "recording_date")
            
        }

        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
     
    static func deletePosts() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Posts")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}


