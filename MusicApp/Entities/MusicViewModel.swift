//
//  MusicViewModel.swift
//  MusicApp
//
//  Created by Nahid Askerli on 19.09.25.
//

import Foundation

protocol MusicViewModelDelegate: AnyObject {
    func render(state: MusicViewModel.State)
}

final class MusicViewModel {
    
    enum State {
        case idle
        case loading
        case result([MusicTrackCell.Item])
        case error(Error)
    }
    
    private let service: APIService
    private let defaults = UserDefaults.standard
    weak var delegate: MusicViewModelDelegate?
    
    init(service: APIService) {
        self.service = service
    }
    
    func subscribe(_ delegate: MusicViewModelDelegate) {
        self.delegate = delegate
    }
    
    func searchMusic(with keyword: String) {
        guard !keyword.isEmpty else {
            self.delegate?.render(state: .idle)
            return
        }
        
        defaults.set(keyword, forKey: "lastSearch")
        delegate?.render(state: .loading)
        
        service.fetchData(searchtext: keyword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    let tracks = DeezerAdapter.adapt(from: model)
                    self?.delegate?.render(state: .result(tracks))
                case .failure(let error):
                    self?.delegate?.render(state: .error(error))
                }
            }
        }
    }
    
    func getLastSearch() -> String? {
        return defaults.string(forKey: "lastSearch")
    }
}
