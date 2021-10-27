//
//  ContentView.swift
//  SwiftyRemoteConfigExample
//
//  Created by 伊藤史 on 2020/08/25.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import SwiftUI
import SwiftyRemoteConfig

struct ContentView: View {
    var body: some View {
        Text(RemoteConfigs.contentText)
            .font(.title)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
