//
//  Section.swift
//  FriendsGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import Foundation

struct Section: Hashable {
    let category: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
    } 
    
}
