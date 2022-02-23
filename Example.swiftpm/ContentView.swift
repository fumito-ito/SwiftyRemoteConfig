import SwiftUI
import Firebase
import SwiftyRemoteConfig

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(RemoteConfigs.contentText)
        }
    }
}
