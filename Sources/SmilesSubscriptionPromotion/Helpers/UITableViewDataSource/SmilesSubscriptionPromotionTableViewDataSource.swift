//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesSharedServices


extension SmilesSubscriptionPromotionVC: UITableViewDataSource, UITableViewDelegate {
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.response?.lifestyleOffers?.count ?? 0
    }

    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmilesSubscriptionPromotionCell", for: indexPath) as! SmilesSubscriptionPromotionCell
        if let offer = self.response?.lifestyleOffers?[indexPath.row] {
           
            let subModel = SmilesSubscriptionTableCellModel()
            subModel.subscriptionTitle = offer.offerTitle
            subModel.subscriptionImg = offer.subscribeImage
            subModel.price = offer.price
            subModel.freeBogoOffer = offer.freeBogoOffer
            subModel.monthlyPrice = offer.monthlyPrice
            subModel.subscriptionDesc = offer.offerDescription
            subModel.model = offer
            if let freeDuration = offer.freeDuration, freeDuration > 0 {
                subModel.trialPeriod = self.response?.themeResources?.subscriptionExpandDescText?[safe: 0]?.replacingOccurrences(of: "%s", with: "\(freeDuration)") ?? ""
            }
            
            if let duration = offer.monthlyPriceCost, !duration.isEmpty {
                subModel.autoRenewPrice = self.response?.themeResources?.subscriptionExpandDescText?[safe: 1]?.replacingOccurrences(of: "%s", with: "\(duration)") ?? ""
            }
            cell.updateCell(rowModel: subModel)
        }
        return cell
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

