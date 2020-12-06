//
//  EditableProductsList.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 06.12.2020.
//  Copyright © 2020 Igor Tiukavkin. All rights reserved.
//

import UIKit
import SmartUI

class EditableProductsList: UIViewController {

    enum DataSource {
        case form
        case product(Product)
    }

    let datasource: Binding<[DataSource]> = .create([.form, .product(.apple)])

    let name: Binding<String> = .create("")
    let info: Binding<String> = .create("")
    let price: Binding<String> = .create("")

    private let grayBackground: Color = Color.gray.opacity(0.1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        ContainerView { [unowned self] in
            self.prosuctsList
        }.layout(in: view)
    }

    private var prosuctsList: View {
        List(self.datasource) { [unowned self] datasource in
            switch datasource {
            case .form:
                return self.addProductForm
            case .product(let product):
                return ProductRow.create(product: product)
            }
        }.beginEndUpdates { [weak self] action in
            self?.info.bind(action.adapt())
        }.separatorInset(UIEdgeInsets(left: 10))
    }

    private var addProductForm: View {
        VStack(spacing: 8.0) { [unowned self] in [
            Text("Add new product")
                .font(Font.system(size: 16))
                .padding(8),
            TextField("Title", text: self.name)
                .font(Font.system(size: 16))
                .padding(8)
                .background(self.grayBackground)
                .cornerRadius(4.0),
            TextEditor("Description", text: self.info)
                .font(Font.system(size: 16))
                .scrollEnabled(false)
                .padding(8)
                .background(self.grayBackground)
                .cornerRadius(4.0),
            TextField("Price", text: self.price)
                .font(Font.system(size: 16))
                .keyboardType(.numbersAndPunctuation)
                .padding(8)
                .background(self.grayBackground)
                .cornerRadius(4.0),
            Button("Add", action: Action { [weak self] in
                self?.addProduct()
            }).disabled(Binding.merge(self.name, self.info, self.price).map { _ -> Bool in
                self.info.value.isEmpty || self.name.value.isEmpty || self.price.value.isEmpty
            })
        ]}.padding(8.0)
    }

    private func addProduct() {
        self.view.endEditing(true)

        // Update datasource
        let emojis = ["🥑", "🥨", "🧀", "🍳", "🍕", "🥘", "🍟"]
        var datasource = self.datasource.value
        let product = Product(
            emojiIcon: emojis.randomElement()!,
            title: self.name.value,
            description: self.info.value,
            price: Double(self.price.value) ?? 0.0
        )
        datasource.append(.product(product))

        // Clean form
        self.name.update("")
        self.info.update("")
        self.price.update("")

        self.datasource.update(datasource)

    }
}

extension NumberFormatter {

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()
}

