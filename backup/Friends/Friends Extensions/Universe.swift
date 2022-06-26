//
//  Universe.swift
//  FriendsGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import Foundation

typealias SectionFriendsTuple = (section: Section, friends: [Friend])

enum Universe: CaseIterable {
    case friends
    case search

    var stubs: [Friend] {
        switch self {
        case .friends:
            return Friend.friends
        case .search:
            return Friend.searchedUsers
        }
    }

    var sectionedStubs: [SectionFriendsTuple] {
        let stubs = self.stubs
        var categoryFriendsDict = [String: [Friend]]()
        stubs.forEach { (friend) in
            let category = friend.category
            if let friends = categoryFriendsDict[category] {
                categoryFriendsDict[category] = friends + [friend]
            } else {
                categoryFriendsDict[category] = [friend]
            }
        }
        let sectionedStubs = categoryFriendsDict.map { (category, items) -> (Section, [Friend]) in
            (Section(category: category), items)
        }.sorted { $0.0.category < $1.0.category }
        return sectionedStubs
    }
}
