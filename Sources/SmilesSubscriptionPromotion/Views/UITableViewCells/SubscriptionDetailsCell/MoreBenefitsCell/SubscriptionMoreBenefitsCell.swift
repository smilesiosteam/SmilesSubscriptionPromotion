//
//  SubscriptionMoreBenefitsCell.swift
//  
//
//  Created by Shmeel Ahmad on 04/10/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager


class SubscriptionMoreBenefitsCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionMoreBenefitRowCell") as! SubscriptionMoreBenefitRowCell
        cell.textLbl.text = offer?.whatYouGetTextList?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        offer!.whatYouGetTextList!.count
    }
    
    @IBOutlet weak var tableVuHgt: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UICustomView!
    
    
    @IBOutlet weak var infoLbl: UILabel!
    //MARK: - IBOutlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var offer:BOGODetailsResponseLifestyleOffer?
    
    @IBOutlet weak var termsBtn: UIButton!
    
    @IBOutlet weak var rowsTableView: UITableView!
    
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
        self.titleLabel.text = self.offer?.whatYouGetTitle
        self.infoLbl.text = self.offer?.disclaimerText
        rowsTableView.reloadData()
        tableVuHgt.constant = rowsTableView.contentSize.height
        
    }
    @IBAction func termPressed(_ sender: Any) {
    }
}
