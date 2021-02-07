//
//  EventsTableViewCell.swift
//  FetchCodingExercise
//
//  Created by Marquis Simmons on 2/6/21.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "EventsCell"
    var event: EventList.Event? = nil
    
    let eventImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.tintColor = .secondaryLabel
        return iv
    }()
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 3
        return label
    }()
    let eventLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let favoritedIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .systemRed
        iv.image = UIImage(systemName: "heart.fill")
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: EventsTableViewCell.reuseIdentifier)
        // Creating Stack View to hold te Event's Name, Date and Location
        let eventInfoStack = UIStackView(arrangedSubviews: [eventTitleLabel,eventLocationLabel,eventDateLabel])
        eventInfoStack.translatesAutoresizingMaskIntoConstraints = false
        eventInfoStack.axis = .vertical
        eventInfoStack.distribution = .fillProportionally
        
        // Setting constraints for all of the cell's subviews

        let eventImageConstraints = [
            eventImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            eventImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            eventImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            eventImage.widthAnchor.constraint(equalTo: eventImage.heightAnchor)
        ]
        let eventInfoStackConstraints = [
            eventInfoStack.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 10),
            eventInfoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            eventInfoStack.topAnchor.constraint(equalTo: contentView.topAnchor)
        ]
        let eventTitleLabelConstraints = [
            eventTitleLabel.leadingAnchor.constraint(equalTo: eventInfoStack.leadingAnchor),
            eventTitleLabel.trailingAnchor.constraint(equalTo: eventInfoStack.trailingAnchor),
            eventTitleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ]
        let eventLocationConstraints = [
            eventLocationLabel.leadingAnchor.constraint(equalTo: eventInfoStack.leadingAnchor),
            eventLocationLabel.trailingAnchor.constraint(equalTo: eventInfoStack.trailingAnchor),
            eventLocationLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.12)
        ]
        let eventDateConstraints = [
            eventDateLabel.leadingAnchor.constraint(equalTo: eventInfoStack.leadingAnchor),
            eventDateLabel.trailingAnchor.constraint(equalTo: eventInfoStack.trailingAnchor),
            eventDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.12)
        ]
        
        let favoritedImageConstraints = [
            favoritedIcon.leadingAnchor.constraint(equalTo: eventImage.leadingAnchor, constant: -5),
            favoritedIcon.topAnchor.constraint(equalTo: eventImage.topAnchor, constant: -5),
            favoritedIcon.heightAnchor.constraint(equalTo: eventImage.heightAnchor, multiplier: 0.40),
            favoritedIcon.widthAnchor.constraint(equalTo: favoritedIcon.heightAnchor)
        ]
        contentView.addSubview(eventImage)
        contentView.addSubview(eventInfoStack)
        contentView.addSubview(favoritedIcon)
        
        NSLayoutConstraint.activate(eventImageConstraints)
        NSLayoutConstraint.activate(eventInfoStackConstraints)
        NSLayoutConstraint.activate(eventTitleLabelConstraints)
        NSLayoutConstraint.activate(eventLocationConstraints)
        NSLayoutConstraint.activate(eventDateConstraints)
        NSLayoutConstraint.activate(favoritedImageConstraints)
        eventImage.layer.cornerRadius = contentView.frame.height/2
    }
    
    
    /// This function creates an Event Cell using data extracted from the passed in Event object
    /// - Parameter event: The Event object this cell represents
    public func configure(with event: EventList.Event){
        let service = NetworkingServices()
        self.event = event
        self.eventTitleLabel.text = event.title
        self.eventLocationLabel.text = event.venue.displayLocation
        self.eventDateLabel.text = event.formatDate()
        self.favoritedIcon.isHidden = !(event.favorited ?? false)
        
        if let eventImageUrl = URL(string: event.performers[0].image) {
            service.getEventPhoto(from: eventImageUrl) {[weak self] result in
                guard let strongSelf = self else { return }
                var eventImage = UIImage(systemName: "exclamationmark.square")
                switch result {
                case .success(let image):
                    eventImage = image
                case .failure:
                    break
                }
                DispatchQueue.main.async {
                    strongSelf.eventImage.image = eventImage
                }
            }

        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
