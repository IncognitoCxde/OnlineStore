//  ProductDetailViewModel

import Foundation

final class ProductDetailViewModel {

     let product: ProductInfo

    init(product: ProductInfo) {
        self.product = product
    }

    var title: String {
        product.title ?? "Product"
    }

    var price: Double {
        product.price ?? 0.0
    }

    var imageName: [String]? {
        product.images
    }

    var description: String {
        product.description ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    }

}
