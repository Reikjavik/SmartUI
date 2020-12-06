//
//  ProductView.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 06.12.2020.
//  Copyright © 2020 Igor Tiukavkin. All rights reserved.
//

import Foundation
import SmartUI

struct ProductRow {

    static func create(product: Product) -> View {
        HStack(alignment: .fill, spacing: 8.0) {[
            VStack {[
                Text(product.emojiIcon)
                    .font(Font.system(size: 40))
                    .padding(8.0)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                    .contentHuggingPriority(.required),
                Spacer()
            ]}.frame(width: 64.0),
            VStack(alignment: .fill, spacing: 4.0) {[
                HStack(alignment: .firstTextBaseline, spacing: 16.0) {[
                    Text(product.title)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 16, weight: .semibold)),
                    Text(product.priceString)
                        .multilineTextAlignment(.trailing)
                        .font(Font.system(size: 14, weight: .bold))
                        .contentHuggingPriority(.required, for: .horizontal)
                ]},
                Text(product.description)
                    .multilineTextAlignment(.leading)
                    .font(Font.system(size: 14, weight: .regular)),
                Spacer()
            ]}
        ]}
        .padding(10.0)
    }
}

struct Product {
    let emojiIcon: String
    let title: String
    let description: String
    let price: Double

    var priceString: String {
        return NumberFormatter.priceFormatter.string(from: NSNumber(value: self.price))!
    }
}

extension Product {

    static var carrot: Product {
        Product(
            emojiIcon: "🥕",
            title: "Carrot",
            description: "The carrot is a root vegetable, usually orange in color, though purple, black, red, white, and yellow cultivars exist. (c) Wikipedia",
            price: 1
        )
    }

    static var avocado: Product {
        Product(
            emojiIcon: "🥑",
            title: "Avocado",
            description: "The avocado, a tree likely originating from south central Mexico, is classified as a member of the flowering plant family Lauraceae. (c) Wikipedia",
            price: 2
        )
    }
    static var apple: Product {
        Product(
            emojiIcon: "🍎",
            title: "Apple",
            description: "An apple is an edible fruit produced by an apple tree. Apple trees are cultivated worldwide and are the most widely grown species in the genus Malus. (c) Wikipedia",
            price: 1.5
        )
    }
}
