# SwiftyRemoteConfig

**Modern Swift API for `FirebaseRemoteConfig`**

SwiftyRemoteConfig makes Firebase Remote Config enjoyable to use by combining expressive Swifty API with the benefits fo static typing. This library is strongly inspired by [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults).

## Features 

There is only one step to start using SwiftyRemoteConfig.

Define your Keys !

```swift
extension RemoteConfigKeys {
    var recommendedAppVersion: RemoteConfigKey<String?> { .init("recommendedAppVersion")}
    var isEnableExtendedFeature: RemoteConfigKey<Bool> { .init("isEnableExtendedFeature", defaultValue: false) }
}
```

... and just use it !

```swift
// get remote config value easily
let recommendedVersion = RemoteConfigs[.recommendedAppVersion]

// eality work with custom deserialized types
let themaColor: UIColor = RemoteConfigs[.themaColor]
```

If you use Swift 5.1 or later, you can also use keyPath `dynamicMemberLookup`:

```swift
let subColor: UIColor = RemoteConfigs.subColor
```

## Usage

### Define your keys

To get the most out of SwiftyRemoteConfig, define your remote config keys ahead of time:

```swift
let flag = RemoteConfigKey<Bool>("flag", defaultValue: false)
```

Just create a `RemoteConfigKey` object. If you want to have a non-optional value, just provide a `defaultValue` in the key (look at the example above).

You can now use `RemoteConfig` shortcut to access those values:

```swift
RemoteConfigs[key: flag] // => false, type as "Bool"
```

THe compiler won't let you fetching conveniently returns `Bool`. 

### Take shortcuts

For extra convenience, define your keys by extending magic `RemoteConfigKeys` class and adding static properties:

```swift
extension RemoteConfigKeys {
    var flag: RemoteConfigKey<Bool> { .init("flag", defaultValue: false) }
    var userSectionName: RemoteConfigKey<String?> { .init("default") }
}
```

and use the shortcut dot syntax:

```swift
RemoteConfigs[\.flag] // => false
```

### Supported types

SwiftyRemoteConfig supports standard types as following:

| Single value | Array |
|:---:|:---:|
| `String` | `[String]` |
| `Int` | `[Int]` |
| `Double` | `[Double]` |
| `Bool` | `[Bool]` |
| `Data` | `[Data]` |
| `Date` | `[Date]` |
| `URL` | `[URL]` |
| `[String: Any]` | `[[String: Any]]` |

and that's not all !

## Extending existing types

### Codable

`SwiftyRemoteConfig` supports `Codable` ! Just conform to `RemoteConfigSerializable` in your type:

```swift
final class UserSection: Codable, RemoteConfigSerializable {
    let name: String
}
```

No implementation needed ! By doing this you will get an option to specify an optional `RemoteConfigKey`:

```swift
let userSection = RemoteConfigKey<UserSection?>("userSection")
```

Additionally, you've get an array support for free:

```swift
let userSections = RemoteConfigKey<[UserSection]?>("userSections")
```

### NSCoding

Support your custom NSCoding type the same way as with Codable support:

```swift
final class UserSection: NSObject, NSCoding, RemoteCOnfigSerializable {
    ...
}
```

### RawRepresentable

And the last, `RawRepresentable` support ! Again, the same situation like with `Codable` and `NSCoding`:

```swift
enum UserSection: String, RemoteConfigSerializable {
    case Basic
    case Royal
}
```

### Custom types

If you want to add your own custom type that we don't support yet. we've got you covered. We use `RemoteConfigBridge` s of many kinds to specify how you get values and arrays of values. WHen you look at `RemoteConfigSerializable` protocol, it expects two properties in eacy type: `_remoteConfig` and `_remoteConfigArray`, where both are of type `RemoteConfigBridge`.

For instance, this is a bridge for single value data retrieving using `NSKeyedUnarchiver`:

```swift
public struct RemoteConfigKeyedArchiveBridge<T>: RemoteConfigBridge {

    public func get(key: String, remoteConfig: RemoteConfig) -> T? {
        remoteConfig.data(forKey: key).flatMap(NSKyedUnarchiver.unarchiveObject) as? T
    }

    public func deserialize(_ object: RemoteConfigValue) -> T? {
        guard let data = object as? Data else {
            return nil
        }

        NSKyedUnarchiver.unarchiveObject(with: data)
    }
}
```

Bridge for default retrieving array values:

```swift
public struct RemoteConfigArrayBridge<T: Collection>: RemoteConfigBridge {
    public func get(key: String, remoteConfig: RemoteConfig) -> T? {
        remoteConfig.array(forKey: key) as? T
    }

    public func deserialize(_ object: RemoteConfigValue) -> T? {
        return nil
    }
}
```

Now, to use these bridges in your type you simply declare it as follows:

```swift
struct CustomSerializable: RemoteConfigSerializable {
    static var _remoteConfig: RemoteConfigBridge<CustomSerializable> { RemoteConfigKeyedArchiverBridge() }
    static var _remoteConfigArray: RemoteConfigBridge<[CustomSerializable]> { RemoteConfigKeyedArchiverBridge() }

    let key: String
}
```

Unfortunately, if you find yourself in a situation where you need a custom bridge, you'll probably need to write your own:

```swift
final class RemoteConfigCustomBridge: RemoteConfigBridge {
    func get(key: String, remoteConfig: RemoteConfig) -> RemoteConfigCustomSerializable? {
        let value = remoteConfig.string(forKey: key)
        return value.map(RemoteConfigCustomSerializable.init)
    }

    func deserializa(_ object: Any) -> RemoteConfigCustomSerializable? {
        guard let value = object as? String {
            return nil
        }

        return RemoteConfigCustomSerializable(value: value)
    }
}

final class RemoteConfigCustomArrayBridge: RemoteConfigBridge {
    func get(key: String, remoteConfig: RemoteConfig) -> [RemoteConfigCustomSerializable]? {
        remoteConfig.array(forKey: key)?
            .compactMap({ $0 as? String })
            .map(RemoteConfigCustomSerializable.init)
    }

    func deserializa(_ object: Any) -> [RemoteConfigCustomSerializable]? {
        guard let values as? [String] else {
            return nil
        }

        return values.map({ RemoteConfigCustomSerializable.init })
    }
}

struct RemoteConfigCustomSerializable: RemoteConfigSerializable, Equatable {
    static var _remoteConfig: RemoteConfigCustomBridge { RemoteConfigCustomBridge() }
    static var _remoteConfigArrray: RemoteConfigCustomArrayBridge: { RemoteConfigCustomArrayBridge() }

    let value: String
}
```

To support existing types with different bridges, you can extend it similarly:

```swift
extension Data: RemoteConfigSerializable {
    public static var _remoteConfigArray: RemoteConfigArrayBridge<[T]> { RemoteConfigArrayBridge() }
    public static var _remoteConfig: RemoteConfigBridge<T> { RemoteConfigBridge() }
}d
```
Also, take a look at our source code or tests to see more examples of bridges. If you find yourself confused with all these bridges, please create an issue and we will figure something out.

## Property wrappers

SwiftyRemoteConfig provides property wrappers for Swift 5.1! The property wrapper, `@SwiftyRemoteConfig`, provides an option to use it with key path and options: caching or observing.

*Caching* means that we will store the value for you and do not hit the `RemoteConfigs` for value almost never, only for the first value fetch.

*Observing* means we will observe, via KVO, your property so you don't have to worry if it was saved somewhere else and you use caching.

Now usage! Given keys:
```swift
extension RemoteConfigKeys {
    var userColorScheme: RemoteConfigKey<String> { .init("userColorScheme", defaultValue: "default") }
    var userThemeName: RemoteConfigKey<String?> { .init("userThemeName") }
    var userLastLoginDate: RemoteConfigKey<Date?> { .init("userLastLoginDate") }
}
```

You can declare a `Settings` struct:
```swift
struct Settings {
    @SwiftyRemoteConfig(keyPath: \.userColorScheme)
    var userColorScheme: String

    @SwiftyRemoteConfig(keyPath: \.userThemeName, options: .cached)
    var userThemeName: String?

    @SwiftyRemoteConfig(keyPath: \.userLastLoginDate, options: [.cached, .observed])
    var userLastLoginDate: Date?
}
```

## KVO

KVO is supported for all the types that are `RemoteConfigSerializable`. However, if you have a custom type, it needs to have correctly defined bridges and serialization in them.

To observe a value for local `RemoteConfigKey`:
```swift
let nameKey = RemoteConfigKey<String>("name", defaultValue: "")
RemoteConfigs.observe(key: nameKey) { update in
	// here you can access `oldValue`/`newValue` and few other properties
}
```

To observe a value for a key defined in `RemoteConfigKey` extension:
```swift
RemoteConfigs.observe(\.nameKey) { update in
	// here you can access `oldValue`/`newValue` and few other properties
}
```


By default we are using `[.old, .new]` options for observing, but you can provide your own:
```swift
RemoteConfigs.observe(key: nameKey, options: [.initial, .old, .new]) { _ in }
```

## KeyPath dynamicMemberLookup

SwiftyRemoteConfig makes KeyPath dynamicMemberLookpu usable in Swift 5.1.

```swift
extension RemoteConfigKeys {
    var recommendedAppVersion: RemoteConfigKey<String?> { .init("recommendedAppVersion")}
    var themaColor: RemoteConfigKey<UIColor> { .init("themaColor", defaultValue: .white) }
}
```

and just use it ;-)

```swift
// get remote config value easily
let recommendedVersion = RemoteConfig.recommendedAppVersion

// eality work with custom deserialized types
let themaColor: UIColor = RemoteConfig.themaColor
```

## Dependencies

- **Swift** version >= 5.0

### SDKs

- **iOS** version >= 11.0

### Frameworks

- **Firebase iOS SDK** >= 6.29.0
- **StoreKit**

## Installation

### Cocoapods

If you're using Cocoapods, just add this line to your `Podfile`:

```ruby
pod 'SwiftyRemoteConfig`, `~> 0.0.1`
```

Install by running this command in your terminal:

```sh
$ pod install
```

Then import the library in all files where you use it:

```swift
import SwiftyRemoteConfig
```

### Carthage

Just add your Cartfile

```
github "fumito-ito/SwiftyRemoteConfig" ~> 0.0.1
```

### Swift Package Manager

Just add to your `Package.swift` under dependencies

```swift
let package = Package(
    name: "MyPackage",
    products: [...],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/SwiftyRemoteConfig.git", .upToNextMajor(from: "0.0.1"))
    ]
)
```

SwiftyRemoteConfig is available under the Apache License 2.0. See the LICENSE file for more detail.