//
//  TitleLabelCollectionViewCell.swift
//  House
//
//  Created by Usman Tarar on 05/08/2020.
//  Copyright © 2020 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

class SubscriptionCancelCollectionViewCell:UICollectionViewCell, CollectionCellAutoLayout {
    
    //MARK: - IBOutlet
    @IBOutlet weak var titleLabe: UILabel!
    
    var cachedSize: CGSize?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RoundedViewConrner(cornerRadius: 12)
        self.cellNonSelectedState()
    }
    
    func setupView() {
    }
    
     func setupStyles() {
        titleLabe.fontTextStyle = .smilesTitle1
        titleLabe.textColor = .black
    }
    
     func updateCell(rowModel: BaseRowModel) {
        if let _ = self.titleLabe {
            self.titleLabe.text = rowModel.rowTitle
        }
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.cellSelectedState()
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.cellNonSelectedState()
                }
            }
        }
    }
    
    func cellSelectedState() {
        self.backgroundColor = UIColor.appPurpleColor1
        self.titleLabe.textColor = .white
        
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func cellNonSelectedState() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.appLightGrayColor2.withAlphaComponent(0.80).cgColor
        
        self.backgroundColor = .white
        self.titleLabe.textColor = .appDarkGrayColor
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return preferredLayoutAttributes(layoutAttributes)
    }
    
    // MARK: - Cell Provider
    
    // __________________________________________________________________________________
    //
    
    class func rowModel(model: CellModel, tag: Int) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "TitleLabelCollectionViewCell"
        rowModel.rowHeight = 36
        let label = UILabel(frame: CGRect.zero)
        label.text = model.title ?? ""
        label.sizeToFit()
        rowModel.rowTitle = model.title ?? ""
        rowModel.rowWidth = label.frame.width + 24
        rowModel.tag = tag
        rowModel.rowValue = model
        return rowModel
    }

}

class CustomViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 12
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        if SmilesLanguageManager.shared.currentLanguage == .ar {
            return true
        } else {
            return false
        }
    }
 
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 12.0
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}


class CellModel: Codable {
    var title: String?

    enum CodingKeys: String, CodingKey {
        case title
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

    func asDictionary() -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded
    }
}
