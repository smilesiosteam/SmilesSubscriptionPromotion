//
//  SubscriptionMoreBenefitsCell.swift
//  
//
//  Created by Shmeel Ahmad on 04/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

protocol SubscriptionMoreBenefitsCellProtocol: AnyObject {
    func didTapOnTermsAndConditions(termsAndConditions: String)
}

class SubscriptionMoreBenefitsCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionMoreBenefitRowCell") as! SubscriptionMoreBenefitRowCell
        cell.textLbl.text = isSubscription ? offer?.whatYouMissTextList?[indexPath.row] : offer?.whatYouGetTextList?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (isSubscription ? offer?.whatYouMissTextList?.count : offer?.whatYouGetTextList?.count) ?? 0
    }
    //MARK: - IBOutlets -
    @IBOutlet weak var tableVuHgt: NSLayoutConstraint!
    @IBOutlet weak var containerView: UICustomView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var rowsTableView: UITableView!
    var isSubscription:Bool { offer?.isSubscription ?? false }
    var offer:BOGODetailsResponseLifestyleOffer?
    public weak var delegate: SubscriptionMoreBenefitsCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.fontTextStyle = .smilesHeadline2
        rowsTableView.registerCellFromNib(SubscriptionMoreBenefitRowCell.self,bundle: .module)
        rowsTableView.dataSource = self
        rowsTableView.delegate = self
    }
    
    func updateCell(offer: BOGODetailsResponseLifestyleOffer) {
        self.offer = offer
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        self.titleLabel.text = isSubscription ? self.offer?.whatYouMissTitle : self.offer?.whatYouGetTitle
        self.infoLbl.text = self.offer?.disclaimerText
        rowsTableView.reloadData()
        tableVuHgt.constant = rowsTableView.contentSize.height
        
    }
    @IBAction func termPressed(_ sender: Any) {
        if let terms = self.offer?.termsAndConditions, let delegate = self.delegate {
            delegate.didTapOnTermsAndConditions(termsAndConditions: terms)
        }
    }
}
