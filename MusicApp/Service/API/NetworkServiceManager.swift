//
//  NetworkServiceManager.swift
//  MusicApp
//
//  Created by Nahid Askerli on 16.09.25.
//

import Foundation

final class NetworkServiceManager {
    private let service: APIService
    init(service: APIService) {
        self.service = service
    }
}
