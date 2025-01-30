//
//  NetworkManager.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import Foundation
import SwiftUI


@Observable
class NetworkManager {
	
	enum NetworkManagerError: Error {
		case malformedData
	}
	
	init() {
		do {
			if !FileManager.default.fileExists(atPath: Self.cacheFilePath) {
				let emptyCache = ImagesCache()
				let emptyCacheData = try JSONEncoder().encode(emptyCache)
				let url = URL(fileURLWithPath: Self.cacheFilePath)
				try emptyCacheData.write(to: url)
				imagesCache = emptyCache
			} else {
				let cacheData = try Data(contentsOf: URL(fileURLWithPath: Self.cacheFilePath))
				let cacheDecoded = try JSONDecoder().decode(ImagesCache.self, from: cacheData)
				imagesCache = cacheDecoded
			}
			var imageDirIsDirectory: ObjCBool = true
			let exists = FileManager.default.fileExists(atPath: Self.cacheImageDirectoryPath, isDirectory: &imageDirIsDirectory)
			if !(exists && imageDirIsDirectory.boolValue) {
				try FileManager.default.createDirectory(at: URL(filePath: Self.cacheImageDirectoryPath), withIntermediateDirectories: true)
			}
		} catch {
			print(error)
			imagesCache = ImagesCache()
		}
	}
	
	enum URLToLoad {
		case normal
		case malformed
		case empty
		
		var urlString : String {
			switch self {
			case .normal:
				return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
			case .malformed:
				return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
			case .empty:
				return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
			}
		}
	}
	
	func fetchData(urlToLoad: URLToLoad = .normal) async throws -> [FetchRecipe] {
		
		let dataURLString = urlToLoad.urlString
		let dataURL = URL(string: dataURLString)!
		let request = URLRequest(url: dataURL)
		let data = try await URLSession.shared.data(for: request)
		do {
			let recipies = try JSONDecoder().decode(RecipesResponse.self, from: data.0)
			return recipies.recipes
		} catch let decodingError as DecodingError {
			throw NetworkManagerError.malformedData
		}
		
	}
	
	func fetchImage(url: URL) async throws -> Data {
		
		if let data = try loadFromCache(url: url) {
			return data
		}
		print("Could not fetch image from cache: \(url)")
		let request = URLRequest(url: url)
		let data = try await URLSession.shared.data(for: request)
		try saveToCache(url: url, data: data.0)
		return data.0
	}
	
	/// Load an image from the cache, if it exists
	/// - Parameter url: URL for the image to load
	/// - Returns: Data for the image if it exists, `nil` if it doesn't exist
	func loadFromCache(url: URL) throws -> Data? {
		/*
		 - Open cache file from disk
		 - If URL isn't in dictionary, return nil
		 - If URL is in dictionary, load that file from the cache
		 */
		guard let imageInfo = imagesCache.images[url.absoluteString] else {return nil}
		let filePath = URL(filePath: Self.cacheImageDirectoryPath)
			.appending(component: imageInfo.uuid, directoryHint: .isDirectory)
			.appending(component: imageInfo.imageName)
		let data = try? Data(contentsOf: filePath)
		return data
	}
	
	/// Save an image to the cache
	/// - Parameters:
	///   - url: URL for the image to save
	///   - data: Data representing the image to be saved
	func saveToCache(url: URL, data: Data) throws {
		/*
		 - generate UUID
		 - add URL and UUID to cache file
		 - save image in temp directory
		 */
		let uuid = UUID()
		let imageName = url.lastPathComponent
		imagesCache.images[url.absoluteString] = .init(uuid: uuid.uuidString, imageName: imageName)
		let folderURL = URL(filePath: Self.cacheImageDirectoryPath).appending(component: uuid.uuidString, directoryHint: .isDirectory)
		try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
		let fileURL = folderURL.appending(component: imageName)
		FileManager.default.createFile(atPath: fileURL.path(), contents: data)
		try flushCacheToDisk()
		
	}
	
	static var cacheFilePath: String {
		return FileManager.default.temporaryDirectory.appending(path: "imageCache.json").path()
	}
	
	static var cacheImageDirectoryPath: String {
		FileManager.default.temporaryDirectory.appending(path: "images").path()
	}
	
	var imagesCache: ImagesCache
	
	func flushCacheToDisk() throws {
		let jsonEncoder = JSONEncoder()
		let jsonData = try jsonEncoder.encode(imagesCache)
		try jsonData.write(to: URL(fileURLWithPath: Self.cacheFilePath))
	}
}

struct RecipesResponse: Codable {
	var recipes: [FetchRecipe]
}

struct ImagesCache: Codable {
	var images: [String: CachedImageInfo] = [:]
}
struct CachedImageInfo: Codable {
	var uuid: String
	var imageName: String
}
