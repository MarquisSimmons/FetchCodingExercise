//
//  EventDetailsViewController.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var favoritedEventDelegate: FavoriteToggleHandler
    var event: EventList.Event
    let service = NetworkingServices()
    
    
    let eventImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.tintColor = .secondaryLabel
        return iv
    }()
    let eventLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    var favoriteButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        configure(with: event)
        setupViews()
        view.backgroundColor = .systemBackground
        
    }
    
    init(with event: EventList.Event, delegate: FavoriteToggleHandler){
        self.favoritedEventDelegate = delegate
        self.event = event
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// This helper function is responsible for adding  constraints to the View's subviews
    func setupViews() {
        // Creating Stack View to hold te Event's Name, Date and Location
        let eventInfoStack = UIStackView(arrangedSubviews: [eventDateLabel, eventLocationLabel])
        eventInfoStack.translatesAutoresizingMaskIntoConstraints = false
        eventInfoStack.axis = .vertical
        eventInfoStack.distribution = .fillProportionally
        
        // Setting constraints for all of the cell's subviews
        let margins = view.layoutMarginsGuide
        
        let eventImageConstraints = [
            eventImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImage.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            eventImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            eventImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            eventImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
        let eventInfoStackConstraints = [
            eventInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            eventInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            eventInfoStack.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 10)
        ]
        
        let eventLocationConstraints = [
            eventLocationLabel.leadingAnchor.constraint(equalTo: eventInfoStack.leadingAnchor),
            eventLocationLabel.trailingAnchor.constraint(equalTo: eventInfoStack.trailingAnchor),
            eventLocationLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ]
        let eventDateConstraints = [
            eventDateLabel.leadingAnchor.constraint(equalTo: eventInfoStack.leadingAnchor),
            eventDateLabel.trailingAnchor.constraint(equalTo: eventInfoStack.trailingAnchor),
            eventDateLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ]
           favoriteButton = UIBarButtonItem(image: getBarButtonStatus(), style: .plain, target: self, action: #selector(favoriteButtonPressed(_:)))
           favoriteButton.tintColor = .red
    
        navigationItem.rightBarButtonItem = favoriteButton
        
        view.addSubview(eventImage)
        view.addSubview(eventInfoStack)
        NSLayoutConstraint.activate(eventImageConstraints)
        NSLayoutConstraint.activate(eventInfoStackConstraints)
        NSLayoutConstraint.activate(eventLocationConstraints)
        NSLayoutConstraint.activate(eventDateConstraints)
        eventImage.layer.cornerRadius = 15
        
    }
    
    /// This function configures the Event Details View Controller using data passed from the Events Table View
    /// - Parameter event: The Event object this page is displaying
    func configure(with event: EventList.Event){
        self.title = event.title
        self.eventLocationLabel.text = event.venue.displayLocation
        self.eventDateLabel.text = event.formatDate()
        
        if let eventImageUrl = URL(string: event.performers[0].image) {
            service.getEventPhoto(from: eventImageUrl) {[weak self] result in
                guard let strongSelf = self else { return }
                var eventImage = UIImage(systemName: "exclamationmark.square")
                switch result {
                case .success(let image):
                    eventImage = image
                case .failure:
                    return
                    
                }
                DispatchQueue.main.async {
                    strongSelf.eventImage.image = eventImage
                }
            }
            
        }
        
    }
    
    func getBarButtonStatus() -> UIImage? {
        var favoritedImage = UIImage(systemName: "heart")
        if let favorited = event.favorited {
             favoritedImage = favorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
        return favoritedImage
    }
    
    @objc func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        self.favoritedEventDelegate.handleFavoriteToggle(for: event)
        self.favoriteButton.image = getBarButtonStatus()

    }
    
}
