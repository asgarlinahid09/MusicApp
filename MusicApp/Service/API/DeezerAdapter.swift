//
//  DeezerAdapter.swift
//  MusicApp
//
//  Created by Nahid Askerli on 19.09.25.
//

final class DeezerAdapter {
    static func adapt(from model: DeezerModels) -> [MusicTrackCell.Item] {
        return model.data?.compactMap { track in
            guard
                let albumImage = track.album?.cover,
                let title = track.title,
                let artist = track.artist?.name,
                let album = track.album?.title,
                let duration = track.duration,
                let preview = track.preview
            else { return nil }

            return MusicTrackCell.Item(
                albumImage: albumImage,
                title: title,
                artist: artist,
                album: album,
                duration: "\(duration) sec",
                preview: preview
            )
        } ?? []
    }
}


