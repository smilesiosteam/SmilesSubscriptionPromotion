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
    
    //MARK: - IBOutlets -
    @IBOutlet weak var containerView: UICustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    var autoScrollTimer: Timer?
    var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var numberOfItems: Int = 0
    var benefits:BenefitsList?
    var bogoLifeStyleOfferModel: BOGODetailsResponseLifestyleOffer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.fontTextStyle = .smilesHeadline2
        self.detailLabel.fontTextStyle = .smilesHeadline4
        collectionView.register(UINib(nibName: "SubscriptionBenefitCollectionCell", bundle: .module), forCellWithReuseIdentifier: "SubscriptionBenefitCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        startAutoScroll()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // Start the auto-scroll timer
    override func prepareForReuse() {
        super.prepareForReuse()
        autoScrollTimer?.invalidate()
    }
    
    func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: 2.0, // Adjust the time interval as needed
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
    }
    func stopTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    @objc func autoScroll() {
        var nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: 0)
        if nextIndexPath.item >= numberOfItems {
                    nextIndexPath.item = 0
            }
        // Scroll to the next cell with animation
        UIView.animate(withDuration: 0.5, animations: {
                  self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: false)
              })
        
        currentIndexPath = nextIndexPath
    }
    
    
    func updateCell(benefits: BenefitsList) {
        self.benefits = benefits
        self.numberOfItems = self.benefits?.images?.count ?? 0
        let textColor = UIColor(hexString: benefits.textColor ?? "#e03d26")
        titleLabel.textColor = textColor
        titleLabel.text = benefits.title
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let attr = benefits.subTitle?.htmlToAttributedString ?? NSAttributedString()
        let attriHtml = NSMutableAttributedString(attributedString: attr)
        attriHtml.addAttributes([.paragraphStyle:style],range: NSRange(location: 0, length: attriHtml.length))
        attriHtml.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(location: 0, length: attriHtml.length))

        detailLabel.attributedText = attriHtml
        containerView.backgroundColor = UIColor(hexString: benefits.backgroundColor ?? "#eb8a2433")
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionBenefitCollectionCell", for: indexPath) as! SubscriptionBenefitCollectionCell
        cell.imageView.setImageWithUrlString(benefits?.images?[safe: indexPath.row] ?? "", defaultImage: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       benefits?.images?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 96, height: 96)
    }
    
}
