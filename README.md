# Finance Manager

Finance Manager will enable users to keep precise and detailed records of their financial transactions by simply adding new entries for each expense or income. With its intuitive approach, the application will greatly simplify the task of tracking expenses and income. This application is designed to meet the diverse needs of users, providing them with control and insight into the financial aspects of their life and assisting them in making informed financial decisions.

## Features

* Biometric authentication
* State management
* Notifications
* Persisting data in sqlite DB
* Models and repositories
* Displaying charts
* Displaying custom UI elements
* Money converter
* Filters
* Reminders
* Dashboards

## Design Patterns
* Singleton: We have implemented notification service and his instantiation can be done only by calling private constructor _internal(). Something similar is done with the database helper.
* Repository: We have implemented a repository pattern for the database. This pattern is used to separate the logic that retrieves the data and the business logic that acts on the data. This way, the business logic can be tested independently from the database.
* Component-based architecture: We have implemented a component-based architecture for the UI. This way, we can reuse the components and the code is more readable and maintainable.

## Web services
We used the Frankfurter API, which is an open-source API for current and historical foreign exchange rates published by the European Central Bank.

## Installation
* Requirements:
  * Flutter installed
  * Android emulator installed
