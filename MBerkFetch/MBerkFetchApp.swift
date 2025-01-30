//
//  MBerkFetchApp.swift
//  MBerkFetch
//
//  Created by Michael Berk on 1/29/25.
//

import SwiftUI

@main
struct MBerkFetchApp: App {
	
	@State var networkManager = NetworkManager()
	
    var body: some Scene {
        WindowGroup {
			ContentView(urlToLoad: .normal)
				.environment(networkManager)
        }
    }
}

extension ProcessInfo {
	var isPreview: Bool {
		return environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
	}
}
