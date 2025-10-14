//
//  DeezerModels.swift
//  MusicApp
//
//  Created by Nahid Askerli on 16.09.25.
//

struct DeezerModels: Decodable {
    let data: [DeezerData]?
    let total: Int?
    
    
    struct DeezerData: Decodable{
        let id: Int?
        let title: String?
        let duration: Int?
        let preview: String?
        let artist: Artist?
        let album: Album?
    }
    struct Artist: Decodable {
        let id: Int?
        let name: String?
        let picture: String?
    }
    struct Album: Decodable{
        let id: Int?
        let title: String?
        let cover: String?
    }
}
