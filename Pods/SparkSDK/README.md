[![Travis CI](https://travis-ci.org/ciscospark/spark-ios-sdk.svg?branch=master)](https://travis-ci.org/ciscospark/spark-ios-sdk)

# SparkSDK

Spark iOS SDK written in swift.

## Setup
Here are the steps to integrate SparkSDK into your Xcode project using [CocoaPods](http://cocoapods.org):

1. Install CocoaPods:
    ```bash
    gem install cocoapods
    ```

1. Setup Cocoapods:
    ```bash
    pod setup
    ```

1. Create a new file "Podfile" with following content in your project directory::

    ```ruby
    source 'https://github.com/CocoaPods/Specs.git'
    
    platform :ios, '8.0'
    use_frameworks!
    
    target 'SparkSDKDemo' do
        pod 'SparkSDK'
    end
    ```

1. Install SparkSDK from your project directory:

    ```bash
    pod install
    ```

## Example
Below is code of a demo of the SDK usage

1. Setup SDK with Spark access token
   ```swift
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let sparkAccessToken = "Yjc5ZTYyMDEt..."
        Spark.initWith(accessToken: sparkAccessToken)
        return true
    }
   ```
1. Setup SDK with app infomation, and authorize access to Spark service
   ```swift
   class LoginViewController: UIViewController {
        @IBAction func loginWithSpark(sender: AnyObject) {
            let clientId = "C90f769..."
            let clientSecret = "64e252..."
            let scope = "spark:people_read spark:rooms_read spark:rooms_write spark:memberships_read spark:memberships_write spark:messages_read spark:messages_write"
            let redirectUri = "SparkSDKDemo://response"
            
            Spark.initWith(clientId: clientId, clientSecret: clientSecret, scope: scope, redirectUri: redirectUri, controller: self)
        }
    }
    ```

1. Register device
    ```swift
    Spark.phone.register() { success in
        if !success {
            print("Failed to register device.")
        }
    }
    ```
            
1. Use Spark service
    
   ```swift
   // IM example
    do {
        // Create a new room
        let room = try Spark.rooms.create(title: "Hello World")
        print("\(room.title!), created \(room.created!): \(room.id!)")
        
        // Add a coworker to the room
        try Spark.memberships.create(roomId: room.id!, personEmail: "coworker@acm.com")

        // List the members of the room
        let memberships = try Spark.memberships.list(roomId: room.id!)
        for membership in memberships {
            print("\(membership.personEmail!)")
        }

        // Post a text message to the room
        try Spark.messages.postToRoom(roomId: room.id!, text: "Hello World")

        // Share a file with the room
        try Spark.messages.postToRoom(roomId: room.id!, files: "http://example.com/hello_world.jpg")
        
    } catch let error as NSError {
        print("Error: \(error.localizedFailureReason)")
    }
    
    // Calling example
    // Make a call
    var outgoingCall =  Spark.phone.dial("coworker@acm.com", option: MediaOption.AudioVideo(local: ..., remote: ...)) { success in
        if !success {
            print("Failed to dail")
        }
    }
    
    // Recieve a call
    class IncomingCallViewController: UIViewController, PhoneObserver {
        override func viewWillAppear(...) {
            ...
            PhoneNotificationCenter.sharedInstance.addObserver(self)
        }
        override func viewWillDisappear(...) {
            ...
            PhoneNotificationCenter.sharedInstance.removeObserver(self)
        }
        func callIncoming(call: Call) {
            // Show incoming call toast view
        }
        ...
    }
    ```
