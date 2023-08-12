//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Sara on 15/2/2023.
//

import Foundation
import UIKit

class PhotoInfoController {
    enum PhotoInfoError: Error, LocalizedError {
        case itemNotFound
        case imageDataMissing
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
    
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PhotoInfoError.imageDataMissing
        }
    
        guard let image = UIImage(data: data) else {
            throw PhotoInfoError.imageDataMissing
        }
    
        return image
    }
    
    func fetchPhotoInfo() async throws -> PhotoInfo {
        let apiKey = "jNceI9Kh5nCUpSD7HneCTVT6pVwYKJZF9VEmJr23"
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "\(apiKey)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return photoInfo
    }
}

//Task {
//    do {
//        let photoInfo = try await fetchPhotoInfo()
//        print("successfully fetched PhotoInfo: \(photoInfo)")
//    } catch {
//        print("Fetch PhotoInfo failed with error: \(error)")
//    }
//}
