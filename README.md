# cat-grouping-exercise
A coding exercise demonstrating the use of several libraries and techniques:

- ReactiveSwift and ReactiveCocoa for fetching data from the API and connecting the data to UI
- Functional programming approach to transforming the data
- Use of Codable/Decodable in Swift4
- Use of SnapKit for simple autolayout management
- Writing asynchronous unit tests and testing functional reactive code

The app simply downloads a list of people and their pets from an API, and then groups the data by filtering out cat names, and grouping them by their owner's gender. This is all displayed in a table view which has pull-to-refresh functionality.

There are a number of ways to improve this example further, such as adding UI tests, improving the UI further, separating table view's data source and delegate into a separate object and so on, but you've got to draw the line somewhere :)

Enjoy!
