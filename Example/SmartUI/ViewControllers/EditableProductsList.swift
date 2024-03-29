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

    enum DataSource: Identifiable {

        case form
        case product(Product)

        var id: String {
            switch self {
            case .form:
                return "form"
            case .product(let product):
                return product.id
            }
        }
    }
    
    let datasource: Publisher<[DataSource]> = .create([.form, .product(.apple)])

    let name: Publisher<String> = .create("")
    let info: Publisher<String> = .create("")
    let price: Publisher<String> = .create("")

    lazy var checkButtonTrigger = self.name.combine(self.info).combine(self.price).mapToVoid()
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
        }.store(in: &self.disposeBag)

        self.checkButtonTrigger.bind { [weak self] in
            guard let self = self else { return }
            let disabled =  self.name.value.isEmpty || self.info.value.isEmpty || self.price.value.isEmpty
            self.buttonDisabled.update(disabled)
        }.store(in: &self.disposeBag)
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
            id: UUID().uuidString,
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

