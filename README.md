# Todo List App

## Overview

The Todo List App is a simple and user-friendly application designed to help users manage their tasks effectively. Built using SwiftUI and Core Data, this app allows users to create, edit, and delete task groups and individual tasks. Users can track their progress visually and categorize tasks into different groups.

## Features

- **Create Task Groups**: Users can create multiple task groups to organize their tasks.
- **Add Tasks**: Easily add individual tasks to any task group.
- **Edit Tasks and Groups**: Update task titles and group names/colors.
- **Delete Tasks and Groups**: Remove tasks and groups that are no longer needed.
- **Completion Tracking**: Mark tasks as completed and visualize progress with a circular progress indicator.
- **Show Completed Tasks**: Toggle the visibility of completed tasks.
- **User-Friendly UI**: Intuitive interface built with SwiftUI.

## Technologies Used

- Swift
- SwiftUI
- Core Data
- UIKit (for color picker)

## Getting Started

### Prerequisites

- Xcode (latest version)
- iOS Simulator or an iOS device

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/flash1729/ToDoList-App.git
Open the project in Xcode:
open TodoListApp.xcodeproj
Run the app on the simulator or a connected device.
Core Data Setup
Ensure that the Core Data model is correctly configured with the following entities:

TaskGroup:
Attributes: id (UUID), name (String), color (String)
Relationships: tasks (To-Many relationship with Task)
Task:
Attributes: id (UUID), title (String), isCompleted (Boolean)
Relationships: group (To-One relationship with TaskGroup)
Usage
Launch the app.
Create a new task group by entering a name and selecting a color.
Add tasks to the selected group by typing the task title and pressing the "+" button.
Mark tasks as completed by tapping on them.
View your progress in the circular progress indicator.
Edit or delete tasks and groups as needed.
Contribution
Contributions are welcome! If you have suggestions or improvements, feel free to submit a pull request or open an issue.

###License
This project is licensed under the MIT License. See the LICENSE file for details.

###Acknowledgments
Thanks to Apple Developer Documentation for their resources on SwiftUI and Core Data.
Inspired by numerous list management applications.
