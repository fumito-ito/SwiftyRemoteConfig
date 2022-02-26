//
//  ViewModel.swift
//  Example
//
//  Created by Fumito Ito on 2022/02/26.
//

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
