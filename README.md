# SwiftyRemoteConfig

![Platforms](https://img.shields.io/badge/platforms-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg)
![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)
![Swift version](https://img.shields.io/badge/swift-5.0-orange.svg)
![Swift version](https://img.shields.io/badge/swift-5.1-orange.svg)
![Swift version](https://img.shields.io/badge/swift-5.2-orange.svg)

**Modern Swift API for `FirebaseRemoteConfig`**

SwiftyRemoteConfig makes Firebase Remote Config enjoyable to use by combining expressive Swifty API with the benefits fo static typing. This library is strongly inspired by [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults).

## HEADS UP ! You need workaround to use with Xcode 13.3 or later

Because of [Xcode compiler bug](https://github.com/apple/swift/issues/58084), you need workaround to use this library with Xcode 13.3 or later.
Followings are recommended steps for workaround.

1. Create `SwiftyRemoteConfig+Workaround.swift` file in module whitch is using `SwiftyRemoteConfig`.
1. Copy the codes below into `SwiftyRemoteConfig+Workaround.swift`. This is pretty much a copy from the `BuiltIns.swift` file in the Sources folder: https://raw.githubusercontent.com/fumito-ito/SwiftyRemoteConfig/master/Sources/SwiftyRemoteConfig/BuiltIns.swift

```swift
import Foundation
import SwiftyRemoteConfig

extension RemoteConfigSerializable {
    public static var _remoteConfigArray: RemoteConfigArrayBridge<[T]> { RemoteConfigArrayBridge() }
}

extension Date: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigObjectBridge<Date> { RemoteConfigObjectBridge() }
}

extension String: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigStringBridge { RemoteConfigStringBridge() }
}

extension Int: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigIntBridge { RemoteConfigIntBridge() }
}

extension Double: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigDoubleBridge { return RemoteConfigDoubleBridge() }
}

extension Bool: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigBoolBridge { RemoteConfigBoolBridge() }
}

extension Data: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigDataBridge { RemoteConfigDataBridge() }
}

extension URL: RemoteConfigSerializable {
    public static var _remoteConfig: RemoteConfigUrlBridge { RemoteConfigUrlBridge() }
    public static var _remoteConfigArray: RemoteConfigCodableBridge<[URL]> { RemoteConfigCodableBridge() }
}

extension RemoteConfigSerializable where Self: Codable {
    public static var _remoteConfig: RemoteConfigCodableBridge<Self> { RemoteConfigCodableBridge() }
    public static var _remoteConfigArray: RemoteConfigCodableBridge<[Self]> { RemoteConfigCodableBridge() }
}

extension RemoteConfigSerializable where Self: RawRepresentable {
    public static var _remoteConfig: RemoteConfigRawRepresentableBridge<Self> { RemoteConfigRawRepresentableBridge() }
    public static var _remoteConfigArray: RemoteConfigRawRepresentableArrayBridge<[Self]> { RemoteConfigRawRepresentableArrayBridge() }
}

extension RemoteConfigSerializable where Self: NSCoding {
    public static var _remoteConfig: RemoteConfigKeyedArchiverBridge<Self> { RemoteConfigKeyedArchiverBridge() }
    public static var _remoteConfigArray: RemoteConfigKeyedArchiverArrayBridge<[Self]> { RemoteConfigKeyedArchiverArrayBridge() }
}

extension Dictionary: RemoteConfigSerializable where Key == String {
    public typealias T = [Key: Value]
    public typealias Bridge = RemoteConfigObjectBridge<T>
    public typealias ArrayBridge = RemoteConfigArrayBridge<[T]>

    public static var _remoteConfig: Bridge { Bridge() }
    public static var _remoteConfigArray: ArrayBridge { ArrayBridge() }
}

extension Array: RemoteConfigSerializable where Element: RemoteConfigSerializable {
    public typealias T = [Element.T]
    public typealias Bridge = Element.ArrayBridge
    public typealias ArrayBridge = RemoteConfigObjectBridge<[T]>

    public static var _remoteConfig: Bridge { Element._remoteConfigArray }
    public static var _remoteConfigArray: ArrayBridge {
        fatalError("Multidimensional arrays are not supported yet")
    }
}

extension Optional: RemoteConfigSerializable where Wrapped: RemoteConfigSerializable {
    public typealias Bridge = RemoteConfigOptionalBridge<Wrapped.Bridge>
    public typealias ArrayBridge = RemoteConfigOptionalBridge<Wrapped.ArrayBridge>

    public static var _remoteConfig: Bridge { RemoteConfigOptionalBridge(bridge: Wrapped._remoteConfig) }
    public static var _remoteConfigArray: ArrayBridge { RemoteConfigOptionalBridge(bridge: Wrapped._remoteConfigArray) }
}
```

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
final class UserSection: NSObject, NSCoding, RemoteConfigSerializable {
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

## Property Wrappers

SwiftyRemoteConfig provides property wrappers for Swift 5.1! The property wrapper, `@SwiftyRemoteConfig`, provides an option to use it with key path.

_Note: This propety wrappers only `read` support. You can set new value to the property, but any changes will NOT be reflected to remote config value_ 

### usage

Given keys:

```swift
extension RemoteConfigKeys {
    var userColorScheme: RemoteConfigKey<String> { .init("userColorScheme", defaultValue: "default") }
}
```

You can declare a Settings struct:

```swift
struct Settings {
    @SwiftyRemoteConfig(keyPath: \.userColorScheme)
    var userColorScheme: String
}
```

You can also check property details with projected value:

```swift
struct Settings {
    @SwiftyRemoteConfig(keyPath: \.newFeatureAvailable)
    var newFeatureAvailable: String
}

struct NewFeatureRouter {
    func show(with settings: Settings) {
        if settings.$newFeatureAvailable.lastFetchTime != nil {
            // show new feature
        } else {
            // fetch and activate remote config before routing
        }
    }
}
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

## Combine

SwiftyRemoteConfig provides values from RemoteConfig with Combine's stream.

```swift
extension RemoteConfigKeys {
    var contentText: RemoteConfigKey<String> { .init("content_text", defaultValue: "Hello, World!!") }
}
```

and get a RemoteConfig's value from Combine stream !

```swift
import FirebaseRemoteConfig
import SwiftyRemoteConfig
import Combine

final class ViewModel: ObservableObject {
    @Published var contentText: String

    private var cancellables: Set<AnyCancellable> = []

    init() {
        contentText = RemoteConfigs.contentText

        RemoteConfig.remoteConfig()
            .combine
            .fetchedPublisher(for: \.contentText)
            .receive(on: RunLoop.main)
            .assign(to: \.contentText, on: self)
            .store(in: &cancellables)
    }
}
```

## Dependencies

- **Swift** version >= 5.0

### SDKs

- **iOS** version >= 11.0
- **macOS** version >= 10.12
- **tvOS** version >= 12.0
- **watchOS** version >= 6.0

### Frameworks

- **Firebase iOS SDK** >= 9.0.0

## Installation

### Cocoapods

If you're using Cocoapods, just add this line to your `Podfile`:

```ruby
pod 'SwiftyRemoteConfig`, `~> 0.4.0`
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
github "fumito-ito/SwiftyRemoteConfig" ~> 0.4.0
```

### Swift Package Manager

Just add to your `Package.swift` under dependencies

```swift
let package = Package(
    name: "MyPackage",
    products: [...],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/SwiftyRemoteConfig.git", .upToNextMajor(from: "0.4.0"))
    ]
)
```

SwiftyRemoteConfig is available under the Apache License 2.0. See the LICENSE file for more detail.
