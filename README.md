# project_assignment_1

User Directory App
A Flutter application for managing user data with CRUD operations, pagination, search functionality, and local persistence. This app uses the BLoC pattern for state management.
Features

View a paginated list of users
View detailed user information
Edit existing users
Add new users
Search users by name or email
Data persistence using SharedPreferences
Shimmer loading effects
Error handling with retry options

Architecture
The application follows a clean architecture approach:
Data Layer

Models: Data classes representing user information
Data Sources:

API Service: Handles API calls
Local Storage Service: Manages local data persistence



Domain Layer

Repository interfaces: Define the contract for data operations

Presentation Layer

BLoC: Manages state and business logic
Screens: UI components for displaying and interacting with data
Widgets: Reusable UI components

Setup Instructions

Clone the repository:
Copygit clone https://github.com/your-username/user-directory.git

Navigate to the project directory:
Copycd user-directory

Install dependencies:
Copyflutter pub get

Run the app:
Copyflutter run


Libraries Used

flutter_bloc: State management
