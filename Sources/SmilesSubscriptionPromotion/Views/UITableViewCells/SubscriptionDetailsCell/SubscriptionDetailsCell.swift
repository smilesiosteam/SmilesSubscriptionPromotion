//
//  SubscriptionDetailsCell.swift
//  
//
//  Created by Shmeel Ahmad on 04/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager


class SubscriptionDetailsCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var containerView: UICustomView!
    
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    var benefits:BenefitsList?
    
    var bogoLifeStyleOfferModel: BOGODetailsResponseLifestyleOffer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.fontTextStyle = .smilesHeadline2
        self.detailLabel.fontTextStyle = .smilesHeadline4
        collectionView.register(UINib(nibName: "SubscriptionBenefitCollectionCell", bundle: .module), forCellWithReuseIdentifier: "SubscriptionBenefitCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateAttributedTextTo(label: UILabel, string: String, subString: String, color:UIColor) {
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            .font: UIFont.circularXXTTBookFont(size: 14),
            .foregroundColor: color,
        ])
        attributedString.addAttribute(.font, value: UIFont.circularXXTTMediumFont(size: 16), range: string.NSRangeof(subString: subString))
        
        label.attributedText = attributedString
    }
    
    
    func updateCell(benefits: BenefitsList) {
        self.benefits = benefits
        let textColor = UIColor(hexString: benefits.textColor ?? "#e03d26")
        titleLabel.textColor = textColor
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let attr = benefits.subTitle?.htmlToAttributedString ?? NSAttributedString()
        let attriHtml = NSMutableAttributedString(attributedString: attr)
        attriHtml.addAttributes([.paragraphStyle:style],range: NSRange(location: 0, length: attriHtml.length))
        detailLabel.attributedText = attriHtml
        containerView.backgroundColor = UIColor(hexString: benefits.backgroundColor ?? "#eb8a2433")
        collectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionBenefitCollectionCell", for: indexPath) as! SubscriptionBenefitCollectionCell
        cell.imageView.setImageWithUrlString(benefits!.images![indexPath.row], defaultImage: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        benefits?.images?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 96, height: 96)
    }
}
