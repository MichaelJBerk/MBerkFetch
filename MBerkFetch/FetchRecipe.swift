//
//  FetchRecipe.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import Foundation

struct FetchRecipe: Codable, Hashable, Identifiable {
	var id: UUID {
		return .init(uuidString: uuid)!
	}
	
	
	var cuisine: String
	var name: String
	var uuid: String
	var photoUrlSmall: URL?
	var photoUrlLarge: URL?
	var sourceUrl: URL?
	var youtubeUrl: URL?
	
	enum CodingKeys: String, CodingKey {
		case cuisine
		case name
		case uuid
		case photoUrlSmall = "photo_url_small"
		case photoUrlLarge = "photo_url_large"
		case sourceUrl = "source_url"
		case youtubeUrl = "youtube_url"
	}
}
