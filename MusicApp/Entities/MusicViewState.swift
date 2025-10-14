//
//  MusicViewState.swift
//  MusicApp
//
//  Created by Nahid Askerli on 19.09.25.
//

import Foundation

enum MusicViewState {
    case idle
    case loading
    case loaded([MusicTrackCell.Item])
    case error(String)
}
