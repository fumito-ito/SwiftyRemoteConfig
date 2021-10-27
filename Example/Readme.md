# SwiftyRemoteConfigExample

## Setup

### 1. Create Firebase project for exmpale

- Before you can add Firebase to your iOS app, you need to create a Firebase project to connect to your iOS app. For more detail, see [Firebase documents](https://firebase.google.com/docs/projects/learn-more).

### 2. Register example app with Firebase

- After you have a Firebase project, you can add your iOS app to it. For more detail, see [Firebase documents](https://firebase.google.com/docs/ios/setup#register-app).

### 3. Set parameter values for `content_text` to RemoteConfig

1. In [Firebase console](https://console.firebase.google.com/), open your project.
1. Select Remote Config from the menu to view Remote Config dashboard
1. Define parameter `content_text` for example project. For the parameter, set some string value e.g. `Hello, SwiftyRemoteConfig!`.

### 4. Add a Firebase configuration file

1. download `GoogleService-Info.plist` from your Firebase project.
1. drag and drop the file into example app

### 5. Add firebase SDKs to exmpale app

1. run `carthage bootstrap --platform iOS`

### 6. Run app!
