//
//  SearchController.swift
//  InstagramCloneWS
//
//  Created by 김우성 on 2021/01/18.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    
    //MARK: - Properties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        // 조건) 서치바를 클릭했는지 여부 && 서치바에 무언가 입력했는지 여부
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
        fetchUsers()
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
}


//MARK: - UITableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
}


//MARK: - UITableViewDelegate

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    
    // (검색창에)무언가 작성할 때마다 이 메소드가 호출됨.
    func updateSearchResults(for searchController: UISearchController) {
        // 1. 작성한 글자를 옵셔널체이닝과 동시에 첫글자 대문자를 제거해준다
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        // 2. filter메소드를 활용하여 users의 데이터 중에서 입력한 글자(searchText)와 일치하는 것만 filtereduser에 할당한다.
        filteredUsers = users.filter({
            $0.username.contains(searchText) ||
                $0.fullname.lowercased().contains(searchText)})
        
        print("DEBUG: Filetered users \(filteredUsers)")
        self.tableView.reloadData()
    }
    
    
}
