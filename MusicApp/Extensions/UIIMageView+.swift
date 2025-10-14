//
//  UIIMageView+.swift
//  MusicApp
//
//  Created by Nahid Askerli on 16.09.25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloadImage(with url: String){
        guard let url = URL(string: url) else {
            self.image = .add
            return
        }
        self.kf.setImage(with: url)
    }
}
