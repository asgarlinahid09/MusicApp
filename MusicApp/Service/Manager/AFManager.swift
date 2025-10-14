//
//  AFManager.swift
//  MusicApp
//
//  Created by Nahid Askerli on 16.09.25.
//

import Foundation
import Alamofire

final class AFManager: APIService {
    func fetchData(
        searchtext: String,
        completion: @escaping (Result<DeezerModels, any Error>) -> Void
    ) {
        guard let url = URL(string: "https://api.deezer.com/search?q=\(searchtext)") else {
            return
        }
        let urlRequest = URLRequest(url: url)
        AF
            .request(urlRequest)
            .responseDecodable(of: DeezerModels.self) { response in
                switch response.result {
                    
                case .success(let deezerData):
                    completion(.success(deezerData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
}
