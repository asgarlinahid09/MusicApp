//
//  MusicTrackCell.swift
//  MusicApp
//
//  Created by Nahid Askerli on 14.09.25.
//

import UIKit
import SnapKit

class MusicTrackCell: UITableViewCell {
    
    var onPlayButtonTapped: ((String) -> Void)?
    private var previewUrl: String?
    
    private let albumImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.boldSystemFont(ofSize: 18)
        tl.numberOfLines = 1
        return tl
    }()
    
    private let artistLabel: UILabel = {
        let al = UILabel()
        al.font = UIFont.systemFont(ofSize: 14)
        al.textColor = .secondaryLabel
        al.numberOfLines = 1
        return al
    }()
    
    private let albumLabel: UILabel = {
        let al = UILabel()
        al.font = UIFont.systemFont(ofSize: 12)
        al.textColor = .tertiaryLabel
        al.numberOfLines = 1
        return al
    }()
    
    private let durationLabel: UILabel = {
        let dl = UILabel()
        dl.font = UIFont.systemFont(ofSize: 12)
        dl.textColor = .secondaryLabel
        dl.textAlignment = .right
        return dl
    }()
    
    private let playButton: UIButton = {
        let pb = UIButton(type: .system)
        pb.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        pb.tintColor = .systemBlue
        pb.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return pb
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        playButton
            .addTarget(
                self,
                action: #selector(didTapPlay),
                for: .touchUpInside
            )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(){
        [albumImageView, titleLabel, artistLabel, albumLabel, durationLabel, playButton].forEach {
            contentView.addSubview($0)
        }
        
    }
    private func setupConstraints(){
        
        
        albumImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(60)
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(40)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(playButton.snp.leading).offset(-8)
            make.bottom.equalTo(contentView).offset(-12)
            make.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.leading.equalTo(albumImageView.snp.trailing).offset(12)
            make.trailing.equalTo(durationLabel.snp.leading).offset(-8)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        albumLabel.snp.makeConstraints { make in
            make.top.equalTo(artistLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(contentView).offset(-12)
        }
        
    }
    
    @objc
    private func didTapPlay (){
        guard let preview = previewUrl else { return }
          onPlayButtonTapped?(preview)
    }
    
}

extension MusicTrackCell {
    struct Item {
        let albumImage: String
        let title: String
        let artist: String
        let album: String
        let duration: String
        let preview: String
    }
    func configure(item: Item) {
        self.albumImageView.downloadImage(with: item.albumImage)
        self.titleLabel.text = item.title
        self.artistLabel.text = item.artist
        self.albumLabel.text = item.album
        self.durationLabel.text = item.duration
        self.previewUrl = item.preview
    }
}
