//
//  MBerkFetchTests.swift
//  MBerkFetchTests
//
//  Created by Michael Berk on 1/29/25.
//

import Testing
@testable import MBerkFetch
import Foundation

struct MBerkFetchTests {
	init() {
		do {
			try FileManager.default.removeItem(atPath: NetworkManager.cacheFilePath)
			try FileManager.default.removeItem(atPath: NetworkManager.cacheImageDirectoryPath)
		} catch {
			print("Failed deleting existing cache")
			print(error)
		}
	}

    @Test func example() async throws {
		
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
	
	@Test func loadDataTest() async throws {
		let networkManager = NetworkManager()
		
		let recipes = try await networkManager.fetchData()
		
		let sampleJSON = """
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
		let sampleRecipe = try JSONDecoder().decode(FetchRecipe.self, from: sampleJSON.data(using: .utf8)!)
		
		#expect(sampleRecipe == recipes.first!)
	}
	
	@Test func emptyDataTest() async throws {
		let networkManager = NetworkManager()
		
		let recipes = try await networkManager.fetchData(urlToLoad: .empty)
		#expect(recipes.isEmpty)
	}
	
	@Test func malformedDataTest() async throws {
		let networkManager = NetworkManager()
		
		await #expect(throws: NetworkManager.NetworkManagerError.malformedData) {
			_ = try await networkManager.fetchData(urlToLoad: .malformed)
		}
		
	}
	
	///Test that images are cached when when they're downloaded
	@Test func loadImageTest() async throws {
		let networkManager = NetworkManager()
		let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
		_ = try await networkManager.fetchImage(url: URL(string: urlString)!)
		let cacheDir = NetworkManager.cacheImageDirectoryPath
		let imageInfo = networkManager.imagesCache.images[urlString]!
		let imagePath = URL(filePath: cacheDir).appending(component: imageInfo.uuid, directoryHint: .notDirectory).appending(component: imageInfo.imageName)
		#expect(FileManager.default.fileExists(atPath: imagePath.path))
	}

}
