// MIT License
//
// Copyright (c) 2021 Igor Tiukavkin.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

protocol DiffableCollection: UIView {

    var sections: [Section] { get set }
    var items: [Section: [AnyHashable]] { get set }
    var updatesDisposeBag: [AnyCancellable] { get set }

    func updateSections(inserted: IndexSet, deleted: IndexSet)
    func updateItems(inserted: [IndexPath], deleted: [IndexPath])
    func reloadData()
}

extension DiffableCollection {

    func reload(sections: [Section]) {
        let uniqueSections = sections.distinct()
        if uniqueSections.count != sections.count {
            print("⚠️ SmartUI: There are duplicates in the sections array provided for collection update. Be careful, this may cause problems. Only unique Sections will be displayed.")
        }
        let diff = Diff(self.sections, uniqueSections)
        guard diff.hasUpdates else { return }
        let isVisible = self.window != nil
        diff.deleted.forEach {
            self.items[$0.1] = nil
        }
        self.sections = uniqueSections
        if isVisible {
            let deleted: [Int] = diff.deleted.map { $0.0 }
            let inserted: [Int] = diff.inserted.map { $0.0 }
            self.updateSections(inserted: IndexSet(inserted), deleted: IndexSet(deleted))
        } else {
            self.reloadData()
        }
        self.bindForSectionsUpdates()
        self.sections.forEach {
            self.updateRows(items: $0.items.value ?? [], in: $0)
        }
    }

    private func bindForSectionsUpdates() {
        self.updatesDisposeBag.forEach { $0.cancel() }
        self.updatesDisposeBag = []
        self.sections.forEach({ section in
            section.items.bind({ [weak section, weak self] newItems in
                guard let section = section else { return }
                self?.updateRows(items: newItems, in: section)
            }).store(in: &self.updatesDisposeBag)
        })
    }

    private func updateRows(items: [AnyHashable], in section: Section) {
        let updates = self.calculateUpdates(old: self.items[section] ?? [], new: items)
        self.items[section] = items
        guard updates.hasUpdates else { return }
        let isVisible = self.window != nil
        if isVisible {
            self.updateItems(inserted: updates.inserted, deleted: updates.deleted)
        } else {
            self.reloadData()
        }
    }

    private func calculateUpdates(old: [AnyHashable], new: [AnyHashable], in section: Int = 0) -> TableUpdate {
        let diff = Diff(old, new)
        let inserted = diff.inserted.map { IndexPath(row: $0.0, section: section) }
        let deleted = diff.deleted.map { IndexPath(row: $0.0, section: section) }
        return TableUpdate(deleted: deleted, inserted: inserted)
    }
}

struct TableUpdate {
    let deleted: [IndexPath]
    let inserted: [IndexPath]

    var hasUpdates: Bool {
        return deleted.count > 0 || inserted.count > 0
    }
}
