//
//  APIService.swift
//  MusicApp
//
//  Created by Nahid Askerli on 16.09.25.
//

protocol APIService {
    func fetchData(searchtext: String,
        completion: @escaping (
            Result <DeezerModels,Error>
        ) -> Void
    )
}
