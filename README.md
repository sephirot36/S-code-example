# S-code-example

Steps to compile:
- Create a folder container
- Via terminal go to the folder.
- Use the command:
```ruby
git clone https://github.com/sephirot36/S-code-example.git
```
- write your user credentials if needed.
- Enter to the folder seat-code generated with the command:
```ruby
cd S-code-example/
```
- Install cocoapods with this command on the project folder:
```ruby
pod install
```
Open the file seat-code.xcworkspace

Compile the version and don't be hard with me :)


# Notes

- The project uses MVVM with RxSwift and avoiding Storyboards.
- I wrote all the "frontend" messages/labels in spanish language because the api give me feedback in spanish, if not it will be a bit weird.
- About Testing, i tried to test unless one file from each layer: 1 View Controller, 1, 1 View Model, 1 Data Resource
- I wrote some TODO's as possible improvements, but did not implement them.
- About the design, it can be better of course, i centered all my effort on the architecture and code.
- About Pods used:
    - GoogleMaps: I considered this is the best framework to show map info, even Apple have's their own maps framework, but i tried to implement the architecture to easily change to other maps framework.
    - RxSwift / RxCocoa: Used to implement observables.
    - SwiftyJSON: Easy way to manage JSON formats
    - Alamofire: Used to do network calls
    - Polyline: Used to decode a route received from the Api.
    - RealmSwift: Used to easily save objects into memory.
    Testing pods: 
    - Quick / Nimble: Easies way to write test


