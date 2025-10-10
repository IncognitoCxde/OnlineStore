//  ImageLoader

import UIKit

extension UIImageView {
    func setImage(from urlString: String?) {
        guard let urlString = urlString, !urlString.isEmpty else { return }
        
        if let url = URL(string: urlString), url.scheme != nil {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { self.image = image }
                }
            }.resume()
        } else {
            self.image = UIImage(named: urlString)
        }
    }
}
