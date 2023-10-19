//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 18/10/2023.
//

import Foundation
import NetworkingLayer

public class SubscriptionCancelResponseModel : BaseMainResponse {
    var status : Int?
    var title : String?
    var description : String?
    var rejectionReasons : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case title = "title"
        case description = "description"
        case rejectionReasons = "rejectionReasons"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        rejectionReasons = try values.decodeIfPresent([String].self, forKey: .rejectionReasons)
        
        try super.init(from: decoder)
    }

}



