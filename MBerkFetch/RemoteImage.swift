//
//  RemoteImage.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import SwiftUI

struct RemoteImage: View {
	@Environment(NetworkManager.self) var networkManager
	
	var imageURL: URL = .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
	
	@State var hasLoaded = false
	@State var imageData: Data?
	
	var body: some View {
		Group {
			if hasLoaded {
				Image(uiImage: .init(data: imageData!)!)
					.resizable()
			} else {
				loadingPlaceholder
			}
		}
		.aspectRatio(contentMode: .fit)
		.task {
			do {
				imageData = try await networkManager.fetchImage(url: imageURL)
				hasLoaded = true
			} catch {
				print("Image Load error: \(error)")
			}
		}
	}
	
	var loadingPlaceholder: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.fill(.placeholder)
				.aspectRatio(1, contentMode: .fit)
			ProgressView()
				.progressViewStyle(.circular)
				.controlSize(.large)
		}
	}
}


#Preview(traits: .sizeThatFitsLayout) {
    RemoteImage()
		.environment(NetworkManager())
}
