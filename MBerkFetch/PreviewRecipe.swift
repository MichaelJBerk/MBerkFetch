//
//  PreviewRecipe.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import Foundation

extension FetchRecipe {
	static let previewRecipe: FetchRecipe = {
		let json = """
{
			"cuisine": "British",
			"name": "Bakewell Tart",
			"photo_url_large": "https://some.url/large.jpg",
			"photo_url_small": "https://some.url/small.jpg",
			"uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
			"source_url": "https://some.url/index.html",
			"youtube_url": "https://www.youtube.com/watch?v=some.id"
		}
"""
		return try! JSONDecoder().decode(FetchRecipe.self, from: json.data(using: .utf8)!)
	}()
	
	static let testRecipe: FetchRecipe = {
		let json = """
 {
			"cuisine": "Malaysian",
			"name": "Apam Balik",
			"photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
			"photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
			"source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
			"uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
			"youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
		}
"""
		return try! JSONDecoder().decode(FetchRecipe.self, from: json.data(using: .utf8)!)
	}()
}
