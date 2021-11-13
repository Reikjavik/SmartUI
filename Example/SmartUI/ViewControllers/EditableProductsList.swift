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

    enum DataSource: Hashable {

        case form
        case product(Product)

        func hash(into hasher: inout Hasher) {
            switch self {
            case .form:
                hasher.combine("form")
            case .product(let product):
                hasher.combine(product)
            }
        }
    }

    let datasource: Publisher<[DataSource]> = .create([.form, .product(.apple)])

    let name: Publisher<String> = .create("")
    let info: Publisher<String> = .create("")
    let price: Publisher<String> = .create("")

    lazy var checkButtonTrigger = Binding.merge(self.name, self.info, self.price).mapToVoid()
    let buttonDisabled: Publisher<Bool> = .create(true)

    private let grayBackground: Color = Color.gray.opacity(0.1)
    private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        ContainerView { [unowned self] in
            self.productsList
        }.layout(in: view)

        self.info.mapToVoid().bind { [weak self] in
            self?.tableView?.beginUpdates()
            self?.tableView?.endUpdates()
        }

        self.checkButtonTrigger.mapToVoid().bind { [weak self] in
            guard let self = self else { return }
            let disabled =  self.name.value.isEmpty || self.info.value.isEmpty || self.price.value.isEmpty
            self.buttonDisabled.update(disabled)
        }
    }

    private var productsList: View {
        TableViewReader { [unowned self] tableView in
            self.tableView = tableView
            return List(self.datasource) { [unowned self] datasource in
                switch datasource {
                case .form:
                    return self.addProductForm
                case .product(let product):
                    return ProductRow.create(product: product)
                }
            }
            .separatorStyle(.none)
        }
    }

    private var addProductForm: View {
        withAnimation(.fade, on: self.datasource) { [unowned self] in
            VStack(spacing: 8.0) {[
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
                Button("Add", action: { [weak self] in
                    self?.addProduct()
                }).disabled(self.buttonDisabled)
            ]}.padding(8.0)
        }
    }

    private func addProduct() {
        self.view.endEditing(true)

        // Update datasource
        let emojis = ["🥑", "🥨", "🧀", "🍳", "🍕", "🥘", "🍟"]
        var datasource = self.datasource.value ?? []
        let product = Product(
            emojiIcon: emojis.randomElement()!,
            title: self.name.value ?? "",
            description: self.info.value ?? "",
            price: Double(self.price.value ?? "") ?? 0.0
        )
        datasource.append(.product(product))

        // Clean form
        self.name.update("")
        self.info.update("")
        self.price.update("")

        self.datasource.update(datasource)
        
    }
}

