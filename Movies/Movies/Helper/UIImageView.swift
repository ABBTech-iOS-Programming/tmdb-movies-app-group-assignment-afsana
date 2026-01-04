import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(url: String) {
        let fullPath = "https://image.tmdb.org/t/p/original" + url
        guard let url = URL(string: fullPath) else { return }
        self.kf.setImage(with: url)
    }
}
