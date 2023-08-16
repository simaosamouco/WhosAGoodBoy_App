# SwordHealthChallenge

This is a Swift application that utilizes the Dog API to display various dog breeds and their details.  
The app uses the MVVM design pattern with dependency injection and integrates various frameworks such as Alamofire, RxSwift, Realm, and SnapKit.

## App Demo
<div align="center">
  <video src="https://github.com/simaosamouco/SwordHealthChallenge/assets/37107794/4f3f6672-46a1-442c-8a59-daf6469e5bfe" width="400" />
</div>

## Features

### 1. List of Dog Breeds Images:
 - Display a list of dog breed images in both list view and grid view.
 - Supports pagination to fetch additional breeds.
 - Option to order the breeds alphabetically.
 - Tap on a breed to view its detailed information.

### 2. Search by Breed Name:
 - Uses a search bar to look up dog breeds by name.
 - Display a list of matching dog breeds with relevant information.
 - Tap on a breed to view its detailed information.

### 3. Detailed Breed View:
 - Present several details of a selected dog breed.
 - Information includes Breed Name, Breed Category, Origin, and Temperament.
 - Option to save dog breed in local storage

### 4. Offline Storage and Display:
 - Supports offline functionality.
 - Display a view that lists dog breeds saved in local storage.

## Frameworks
The App is built using the following frameworks:

 - **Alamofire**: Used for making API requests and handling network communication.
 - **RxSwift**: Implemented to manage reactive programming, observables, and bindings.
 - **Realm**: Used for local data storage and management.
 - **SnapKit**: Used for simplifying Auto Layout constraints and UI layout.

 ## View Code
This application utilizes a view code approach instead of storyboards for building user interfaces. 
This approach promotes cleaner and more maintainable code.
It also takes into consideration the benefits it offers in a team environment.
Utilizing View Code enhances code review processes and simplifies the resolving merge conflicts.

## Getting Started
To explore the App, follow these steps:

 - Clone the repository to your local machine.
 - Open the **.xcworkspace** file in Xcode.
 - Run the app on the desired simulator or device.
