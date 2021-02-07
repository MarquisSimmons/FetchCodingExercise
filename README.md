# Fetch Rewards Take home Assessment

This is a simple app page that fetches Events from Seat Geek and displays them to a user inside of a TableView.  When a user taps a cell they will be brought to the Details Page for that event where they can favorite or un-favorite an event. The favorited events are being persisted through UserDefaults.

## Build Tools & Version Used

Xcode 12.0 was used to develop this but the Project is compatible with Xcode 9.3

iOS Deployment target: iOS 14.2

## Areas of Focus
My main area of focus was the architecture of the App. I wanted to make sure each class had its own specific responsibilities and I tried to make sure the code was open to future modifications. I minimalized the repetition of code and created helper functions where I believed were necessary to make sure there were no redundancies. What I enjoyed most was making the UI even though it is very simple I love organizing my views and subviews with programmatic constraints. I know I was not directed to but I tried my best to match the UI that was provided in the mockups


## Copied-in code/dependencies
No external dependencies were used for this project.

Unit testing is not one of my strengths and I was a bit confused about how I would test my APILoader class without actually making network calls. To address this I copied the [MockURLProtocol class, and XCTestCase+JSON class](https://medium.com/dev-genius/unit-test-networking-code-in-swift-without-making-loads-of-mock-classes-74489d0b12a8) to help get me started with testing the EventsAPI.

## Tablet/Phone Focus
I focused on the iPhone 11 Pro device specifically for the UI of this App.

## Time Spent
About 5 hours