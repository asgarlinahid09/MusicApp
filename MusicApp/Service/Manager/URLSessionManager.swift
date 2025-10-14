//
//  URLSessionManager.swift
//  MusicApp
//
//  Created by Nahid Askerli on 16.09.25.
//

import Foundation


final class URLSessionManager: APIService {
    static let shared = URLSessionManager()
    func fetchData(
        searchtext: String,
        completion: @escaping (Result<DeezerModels, any Error>) -> Void
    ) {
        guard let url = URL(string:  "https://api.deezer.com/search?q=\(searchtext)") else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: urlRequest) {
                data,
                response,
                error in
                if let error = error {
                    print("Xeta bas verdi error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(
                            DeezerModels.self,
                            from: data
                        )
                        completion(.success(model))
                    }
                    
                    catch {
                        print("Decoding error ... \(error)")
                        return
                    }
                }
            }
        task.resume()
    }
    
    
}
