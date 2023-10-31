//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 06/10/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesSharedServices


extension SmilesSubscriptionDetailsVC: UITableViewDataSource, UITableViewDelegate {
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (offer?.isSubscription ?? false) ? 2 : (self.benefitsResponse?.benefitsList?.count ?? 0) + (offer != nil ? 1 : 0)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (offer?.isSubscription ?? false){
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribedInfoCell", for: indexPath) as! SubscribedInfoCell
                cell.updateCell(offer: self.offer!, bogoResponse: self.bogoDetailsResponse)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionMoreBenefitsCell", for: indexPath) as! SubscriptionMoreBenefitsCell
                cell.updateCell(offer: self.offer!,bogoResponse: self.bogoDetailsResponse)
                cell.delegate = self
                return cell
            }
        }else{
            if indexPath.row >= (benefitsResponse?.benefitsList?.count ?? 0)  && offer != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionMoreBenefitsCell", for: indexPath) as! SubscriptionMoreBenefitsCell
                cell.updateCell(offer: self.offer!)
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionDetailsCell") as! SubscriptionDetailsCell
                cell.updateCell(benefits: benefitsResponse!.benefitsList![indexPath.row])
                return cell
            }
        }
    }

    
    public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    public  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
   
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.didScrollTableView(scrollView:scrollView)
    }
}

