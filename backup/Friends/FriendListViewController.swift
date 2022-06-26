//
//  FriendListViewController.swift
//  FriendsGrid
//
//  Created by Alfian Losari on 10/11/20.
//

import Combine
import SwiftUI
import UIKit
import CoreData

class FriendListViewController: UIViewController, UISearchBarDelegate {
    
    private var collectionView: UICollectionView!
//    private var segmentedControl = UISegmentedControl(
//        items: Universe.allCases.map { $0.title }
//    )
    
    var isSearching = false
    var backingStore: [SectionFriendsTuple]
    private var dataSource: UICollectionViewDiffableDataSource<Section, Friend>!
    
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var cellRegistration: UICollectionView.CellRegistration<FriendCell, Friend>!
    private var headerRegistration: UICollectionView.SupplementaryRegistration<FriendCell>!
    
    private lazy var listLayout: UICollectionViewLayout = {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfig.headerMode = .supplementary
        listConfig.backgroundColor = UIColor.rgb(red: 29, green: 28, blue: 27)
        listConfig.showsSeparators = false
        
        return UICollectionViewCompositionalLayout.list(using: listConfig)
        
    }()
    
    private lazy var navBar: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.rgb(red: 29, green: 28, blue: 27)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        return view
        
    }()
    
    private lazy var mainView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.rgb(red: 29, green: 28, blue: 27)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var handle: UILabel = {
        var label = UILabel()
        label.text = ""
        label.backgroundColor = UIColor.rgb(red: 83, green: 83, blue: 82)//.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit
        label.clipsToBounds = true
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        
        
        sb.barTintColor = UIColor.rgb(red: 29, green: 28, blue: 27) //UIColor.rgb(red: 29, green: 28, blue: 27) //UIColor.rgb(red: 50, green: 50, blue: 50)
        sb.autocapitalizationType = .none
        sb.autocorrectionType = .no
         
//        sb.searchTextField.attributedText =  NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 255, green: 255, blue: 255), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        // cancel button
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 209, green: 209, blue: 209), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)], for: .normal)
         
//        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
         
        sb.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Add a new friend", attributes: [NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 212, green: 212, blue: 212), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
//        sb.showsCancelButton = true
        
        if let leftView = sb.searchTextField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor.rgb(red: 215, green: 215, blue: 215)
        }
        
        
        sb.clipsToBounds = true
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.delegate = self
//        sb.searchResultsUpdater = self
        return sb
    }()
        
    init(sectionedFriends: [SectionFriendsTuple] = Universe.friends.sectionedStubs) {
        self.backingStore = sectionedFriends
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear//UIColor.rgb(red: 29, green: 28, blue: 27)
        navigationController?.navigationBar.isHidden = true
        setupSearchBar()
        setupCollectionView()
        setupShadow()
        setupSearchTextObserver()
        setupDataSource()
        setupSnapshot(store: backingStore)
        
        
        print(Friend.friends)

    }
    
    private func setupSearchBar() {
        view.addSubview(navBar)
        navBar.addSubview(handle)
        navBar.addSubview(searchBar)
        
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        handle.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        handle.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive = true
        handle.heightAnchor.constraint(equalToConstant: 6).isActive = true
        handle.widthAnchor.constraint(equalToConstant: 40).isActive = true
        handle.layer.cornerRadius = 3
        
        
        searchBar.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 20).isActive = true
        searchBar.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: 10).isActive = true
        searchBar.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.updateHeight(height: 50, radius: 15)
//        var bounds: CGRect
//        bounds = searchBar.frame
//        bounds.size.height = 60 //(set height whatever you want)
//        bounds.size.width = 60
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).bounds = bounds
                
        navBar.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50).isActive = true
        
    }
    
    func setupShadow() {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgb(red: 29, green: 28, blue: 27).cgColor, UIColor(red: 29/255, green: 28/255, blue: 27/255, alpha: 0.95).cgColor, UIColor(red: 29/255, green: 28/255, blue: 27/255, alpha: 0.7).cgColor, UIColor(red: 29/255, green: 28/255, blue: 27/255, alpha: 0.2).cgColor, UIColor(red: 29/255, green: 28/255, blue: 27/255, alpha: 0).cgColor]
        gradientLayer.frame = CGRect.init(x: view.frame.minX, y: searchBar.frame.minY, width: view.frame.width, height: 20)
        gradientLayer.masksToBounds = true
        mainView.layer.insertSublayer(gradientLayer, above: collectionView.layer)//, below: searchBar.layer)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if isSearching {
            print("update search")
            searchUser(username: searchText ?? "")
        } else {
            print("not searching ")
            self.backingStore = Universe.friends.sectionedStubs
            searchTextSubject.send(searchBar.text ?? "")
        }
        
        
//        searchTextSubject.send(searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        isSearching = false
        
        self.searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Add a new friend", attributes: [NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 212, green: 212, blue: 212), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        searchBar.text = nil
        self.searchBar.showsCancelButton = false
        
        self.backingStore = Universe.friends.sectionedStubs
        searchTextSubject.send(searchBar.text ?? "")
        
        searchBar.resignFirstResponder()
        print("123 searchBar.resignFirstResponder")
    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        print("begin editing")
//        return true
//    }
//
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
         
        self.searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search users", attributes: [NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 114, green: 111, blue: 109), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        self.searchBar.showsCancelButton = true
        print("begin editing")
        
        self.backingStore = Universe.search.sectionedStubs
//        self.backingStore = self.backingStore.map { ($0.section, $0.friends) }
        setupSnapshot(store: backingStore)
        
        
    }
    
    
    private func setupCollectionView() {
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        
        collectionView = .init(frame: mainView.bounds, collectionViewLayout: listLayout)
        collectionView.backgroundColor = UIColor.rgb(red: 29, green: 28, blue: 27) //systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.addSubview(collectionView)
        
        cellRegistration = UICollectionView.CellRegistration(
            handler: { (cell: FriendCell, _, friend: Friend) in
//                var content = cell.defaultContentConfiguration()
//                content.text = friend.name
//                content.secondaryText = friend.job
//                content.image = UIImage(named: friend.imageName)
//                content.imageProperties.maximumSize = .init(width: 60, height: 60)
//                content.imageProperties.cornerRadius = 30
//
//                cell.contentConfiguration = content
                
//                cell.nameLabel.text = friend.name
//                cell.usernameLabel.text = friend.job
//                cell.viewButton.setTitle(friend.category, for: .normal)
//                cell.widthAnchor = view.frame.width// CGSize(width: view.frame.width, height: 66)
                cell.viewButton.accessibilityHint = friend.uid
                cell.viewButton.addTarget(self, action: #selector(self.cellButtonPressed), for: .touchUpInside)
                
                cell.deleteButton.accessibilityHint = friend.uid
                cell.deleteButton.addTarget(self, action: #selector(self.cellButtonPressed), for: .touchUpInside)
                
                cell.acceptButton.accessibilityHint = friend.uid
                cell.acceptButton.addTarget(self, action: #selector(self.cellButtonPressed), for: .touchUpInside)
                  
                cell.friend = friend
                
                
            })
        
        headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader, handler: { [weak self](header: FriendCell, _, indexPath) in
            guard let self = self else { return }
            self.configureHeaderView(header, at: indexPath)
        })
    }
    
    @objc func cellButtonPressed(_ sender: UIButton) {
        
        let section = sender.accessibilityHint
//        print("cellButtonPressed: ", section!)
        
        
        if let userIndex = Friend.findUserPos(uid: section!, array: Friend.friends) {
//            print(userIndex)
//            print("selected user: ", Friend.users[userIndex])
            let category = Friend.friends[userIndex].category
            print("category:", category)
            
            if category == "friends" {
                Friend.friends[userIndex].category = "suggestions"
                
            } else if category == "received_friend_requests" {
                Friend.friends[userIndex].category = "friends"
                
            } else if category == "sent_friend_requests" {
                Friend.friends[userIndex].category = "suggestions"
                
            } else if category == "suggestions" {
                Friend.friends[userIndex].category = "sent_friend_requests"
                
            } else if category == "search" {
                Friend.friends[userIndex].category = "friends"
                
            }
            Friend.refreshFriends()
            
            self.resetToFriends()
            
        } else if isSearching {
            if let userIndex = Friend.findUserPos(uid: section!, array: Friend.searchedUsers) {
                let category = Friend.searchedUsers[userIndex].category
                print("category:", category)
                Friend.searchedUsers[userIndex].category = "sent_friend_requests"
                Friend.friends.append(Friend.searchedUsers[userIndex])
                Friend.searchedUsers.remove(at: userIndex)
                Friend.refreshFriends()
                self.searchBarCancelButtonClicked(searchBar)
                self.resetToFriends()
            }
        }
        
    }
    
    
    private func setupDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, friend) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: friend)
            
            return cell
        })
        
        
        
        dataSource.supplementaryViewProvider = { [weak self](collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let self = self else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(using: self.headerRegistration, for: indexPath)
            return headerView
        }
    }
    
    private func setupSnapshot(store: [SectionFriendsTuple]) {
        var snapshot = NSDiffableDataSourceSnapshot<FriendsGrid.Section, Friend>()
        store.forEach { (sectionFriends) in
            let (section, friends) = sectionFriends
            snapshot.appendSections([section])
            snapshot.appendItems(friends, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true, completion: reloadHeaders)
    }
     
    
    private func setupSearchTextObserver() {
        searchTextSubject
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .map { $0.lowercased() }
            .sink { [weak self] (text) in
                guard let self = self else { return }
                if text.isEmpty {
                    self.setupSnapshot(store: self.backingStore)
                } else {
                    let searchStore = self.backingStore
                        .map {
                            ($0.section, $0.friends
                                .filter { $0.username.lowercased().contains(text) }
                            )
                        }.filter { !$0.1.isEmpty }
                    self.setupSnapshot(store: searchStore)
                }
            }
            .store(in: &cancellables)
    }
    
//    @objc private func segmentChanged(_ sender: UISegmentedControl) {
//        backingStore = sender.selectedUniverse.sectionedStubs
//        setupSnapshot(store: backingStore)
//    }
    
//    @objc private func shuffleTapped(_ sender: Any) {
//        self.backingStore = self.backingStore.shuffled().map { ($0.section, $0.friends.shuffled()) }
//        setupSnapshot(store: backingStore)
//    }
    
    @objc private func resetToFriends() {
        backingStore = Universe.friends.sectionedStubs
        setupSnapshot(store: backingStore)
    }
    
    @objc private func searchUser(username: String) {
//        let sectionedFriends =
        self.backingStore = Universe.search.sectionedStubs
//        self.backingStore = self.backingStore.map { ($0.section, $0.friends) }
//        setupSnapshot(store: backingStore)
        
        let searchStore = self.backingStore.map { ($0.section, $0.friends.filter { $0.username.lowercased().contains(username) } ) }.filter { !$0.1.isEmpty }
        self.setupSnapshot(store: searchStore)
    }
    
    private func reloadHeaders() {
        collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader).forEach { (indexPath) in
            guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? FriendCell else {
                return
            }
            self.configureHeaderView(header, at: indexPath)
        }
    }
    
    private func configureHeaderView(_ headerView: FriendCell, at indexPath: IndexPath) {
        guard
            let item = dataSource.itemIdentifier(for: indexPath),
            let section = dataSource.snapshot().sectionIdentifier(containingItem: item)
        else {
            return
        }
        let count = dataSource.snapshot().itemIdentifiers(inSection: section).count
//        var content = headerView.defaultContentConfiguration(text: <#String#>)
        let category = section.category//.headerTitleText(count: count)
        headerView.defaultContentConfiguration(category: category)
//        headerView.contentConfiguration = content
    }
    
    
        
    required init?(coder: NSCoder) {
        fatalError("Please initialize programatically instead of using Storyboard/XiB")
    }

}

//extension FriendListViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        searchTextSubject.send(searchController.searchBar.text ?? "")
//    }
//
//}

struct FriendListViewControllerRepresentable: UIViewControllerRepresentable {
    
    let sectionedFriends: [SectionFriendsTuple]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: FriendListViewController(sectionedFriends: sectionedFriends))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}

//struct FriendList_Previews: PreviewProvider {
//
//    static var previews: some View {
//        FriendListViewControllerRepresentable(sectionedFriends: Universe.ff7r.sectionedStubs)
//            .edgesIgnoringSafeArea(.vertical)
//    }
//
//}

extension UISearchBar {
    func updateHeight(height: CGFloat, radius: CGFloat) {
        let image: UIImage? = UIImage.imageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                        }
                    }
                    continue
                }
                if let textField = subSubViews as? UITextField {
                    textField.layer.cornerRadius = radius
                    textField.clipsToBounds = true
                }
            }
        }
    }
}

private extension UIImage {
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}
