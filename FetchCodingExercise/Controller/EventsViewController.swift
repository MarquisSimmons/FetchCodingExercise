//
//  ViewController.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import UIKit

class EventsViewController: UIViewController {
    
    let eventsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventsTableViewCell.self, forCellReuseIdentifier: EventsTableViewCell.reuseIdentifier)
        return tableView
    }()
    // This label should be displayed when there are no Events listed
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sorry, there was an error retrieving the events. Please try again later."
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .default
        bar.sizeToFit()
        bar.placeholder = "Search for an Event..."
        bar.showsCancelButton = true
        return bar
    }()
    var listOfEvents = [EventList.Event]()
    var filteredEvents = [EventList.Event]()
    let service = NetworkingServices()
    var favoritedData = UserDefaults.standard.object(forKey: "favorited-events") as? Data
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        searchBar.delegate = self
        setupViews()
        fetchEvents()
        
    }
    /// This helper function is responsible for adding  constraints to the View's subviews
    fileprivate func setupViews() {
        let eventsTableViewConstraints = [
            eventsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        let errorLabelConstraints = [
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 400),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        
        eventsTableView.tableHeaderView = searchBar
        view.addSubview(eventsTableView)
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate(eventsTableViewConstraints)
        NSLayoutConstraint.activate(errorLabelConstraints)
        
    }
    fileprivate func fetchEvents() {
        service.getEvents { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let eventList):
                strongSelf.listOfEvents = eventList
                strongSelf.filteredEvents = strongSelf.listOfEvents
                DispatchQueue.main.async {
                    if strongSelf.listOfEvents.isEmpty {
                        strongSelf.eventsTableView.isHidden = true
                        strongSelf.errorLabel.isHidden = false
                        strongSelf.errorLabel.text = "Hmm. Looks like there aren't any events."
                    }
                    strongSelf.eventsTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.eventsTableView.isHidden = true
                    strongSelf.errorLabel.isHidden = false
                }
                print("There was an error while trying to retrieve the events \(error.localizedDescription)")
                
            }
        }
    }
}

// MARK: - TableView Delegate and DataSource Methods
extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.reuseIdentifier, for: indexPath) as! EventsTableViewCell
        cell.configure(with: filteredEvents[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = filteredEvents[indexPath.item]
        let detailsViewController = EventDetailsViewController(with: event, delegate: self)
        navigationController?.pushViewController(detailsViewController, animated: true)
        
        
    }
    
}

// MARK: - UISearchbar Delegate Methods and helpers
extension EventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let enteredText = searchBar.text {
            if enteredText.isEmpty{
                resetTableView()
            }
            else {
                filterEvents(with: enteredText)
            }
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let enteredText = searchBar.text {
            if !enteredText.isEmpty {
                filterEvents(with: enteredText)
            }
            else {
                resetTableView()
            }
        }
        else {
            resetTableView()
        }
    }
    
    /// Filters events whose Title or location containts the search bar's text
    /// - Parameter text: the current text in the search bar
    fileprivate func filterEvents(with text: String) {
        filteredEvents = listOfEvents.filter({ (event) -> Bool in
            return event.title.lowercased().contains(text.lowercased())
                || event.venue.displayLocation.lowercased().contains(text.lowercased())
        })
        eventsTableView.reloadData()
    }
    
    /// This function displays all events when the seatch bar is empty
    fileprivate func resetTableView() {
        filteredEvents = listOfEvents
        eventsTableView.reloadData()
        self.searchBar.resignFirstResponder()
        
    }
    
    
}

// MARK: - Event Updater, the object responsible for handling when Event's favorite field is being changed
extension EventsViewController: FavoriteToggleHandler {
    func handleFavoriteToggle(for event: EventList.Event) {
        if event.favorited == nil {
            event.favorited = true
        }
        else {
            event.favorited!.toggle()
        }
        guard var favoritedSet = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(favoritedData!) as? Set<Int>
        else {
            fatalError("Favorite Event Set does not exist!")
        }
        if event.favorited! {
            favoritedSet.insert(event.id)
        }
        else {
            favoritedSet.remove(event.id)
        }
        let encodedSet = try? NSKeyedArchiver.archivedData(withRootObject: favoritedSet, requiringSecureCoding: false)
        UserDefaults.standard.setValue(encodedSet, forKey: "favorited-events")
        eventsTableView.reloadData()
    }
    
}



