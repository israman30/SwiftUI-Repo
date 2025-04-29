import UIKit

/**
 Model-View-Intent (MVI) is a popular architecture in the Android world. It was introduced by Hannes Dorfmann.
 You can find it here. https://hannesdorfmann.com/android/mosby3-mvi-1/
 For the purpose of this article, a brief introduction to MVI is presented below.
 
 `MVI is a cyclical and unidirectional data-flow architecture.
 
 - `The Model represents the state of the application. It contains the properties necessary to render the screen.
 - `An Intent is an event to change the state of the system — e.g., user click is an event to change the state of the system. Also, call it [Interaction].
 - `View observes the state change and updates itself accordingly.
 
    `View -> Intent -> Model -> View...
 `1. The user interacts with the View to create an Intent.
 `2. The Intent changes the state of the application.
 `3. A change in state updates the View. The cycle repeats.
 
 `MVI Implementation in SwiftUI
 - For demonstration purposes, we’ll implement a movie-search screen. It has a TextField to type in the keyword to search. Below is the list of movies matching the keyword.
 
 `Model (State of the Application)
 - First up, let’s consider the possible states of the application. At any given time, the application will be in one of the following states. Later, you’ll see that we have a view for each of the corresponding state.
 */
/**
 `- InitState: It’s an initial state. Nothing has been queried.
 `- Loading: The keyword has been entered, and movies are being fetched from the API
 `- SuccessfullyFetched: When the API returns the matching movies
 `- NoMatchingResults: When no results are found for the query
 `- ApiError: The HTTP request failed or the API returned an error
 We will use Swift’s `Enum` to hold the states.
 */
