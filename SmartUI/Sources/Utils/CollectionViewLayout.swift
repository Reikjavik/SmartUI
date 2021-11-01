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

internal class DefaultCollectionViewLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

internal class LeftAlignedLayout: DefaultCollectionViewLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = self.sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + self.minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

internal class CenterAlignedLayout: DefaultCollectionViewLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let leftPadding: CGFloat = self.sectionInset.left
        let interItemSpacing = self.minimumInteritemSpacing
        var leftMargin: CGFloat = leftPadding
        var maxY: CGFloat = -1.0
        var rowSizes: [[CGFloat]] = []
        var currentRow: Int = 0
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = leftPadding
                if rowSizes.count == 0 {
                    rowSizes = [[leftMargin, 0]]
                } else {
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = leftPadding
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0]
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                currentRow += 1
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

class RightAlignedLayout: LeftAlignedLayout {

    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }

    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        return UIUserInterfaceLayoutDirection.rightToLeft
    }
}
