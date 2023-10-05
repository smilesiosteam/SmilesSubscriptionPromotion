//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 05/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager

class SmilesSubsciptionTutorialRequestModel: SmilesBaseMainRequest {
    var operationName: String?
    var sectionKey: String?
    
    
    enum CodingKeys: String, CodingKey {
        case operationName
        case sectionKey
    }
    
    public init(operationName: String?, sectionKey: String) {
        self.operationName = operationName
        self.sectionKey = sectionKey
        super.init()
    }
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.operationName, forKey: .operationName)
        try container.encodeIfPresent(self.sectionKey, forKey: .sectionKey)
    }
}

// MARK: - Video Tutorial Response

class SmilesSubsciptionVideoTutorialResponse: BaseMainResponse {
    let videoTutorial: SmilesSubsciptionVideoTutorial?
    
    enum CodingKeys: String, CodingKey {
        case videoTutorial = "videoTutorial"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        videoTutorial = try values.decodeIfPresent(SmilesSubsciptionVideoTutorial.self, forKey: .videoTutorial)
        try super.init(from: decoder)
    }
}

// MARK: - VideoTutorial
 class SmilesSubsciptionVideoTutorial: BaseMainResponse {
    let videoURL: String?
    let thumbnailImageURL: String?
    let sectionKey: String?
    let numOfDays: Int?
    let watchKey: String?
    
    enum CodingKeys: String, CodingKey {
        case videoURL = "videoUrl"
        case thumbnailImageURL = "thumbnailImageUrl"
        case sectionKey = "sectionKey"
        case numOfDays
        case watchKey = "watchKey"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        videoURL = try values.decodeIfPresent(String.self, forKey: .videoURL)
        thumbnailImageURL = try values.decodeIfPresent(String.self, forKey: .thumbnailImageURL)
        sectionKey = try values.decodeIfPresent(String.self, forKey: .sectionKey)
        numOfDays = try values.decodeIfPresent(Int.self, forKey: .numOfDays)
        watchKey = try values.decodeIfPresent(String.self, forKey: .watchKey)
        try super.init(from: decoder)
    }
}

