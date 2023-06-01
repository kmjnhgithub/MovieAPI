//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by mike liu on 2023/5/31.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
