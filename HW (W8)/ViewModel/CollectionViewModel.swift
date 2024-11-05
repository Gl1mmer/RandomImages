//
//  CollectionViewModel.swift
//  HW (W8)
//
//  Created by Amankeldi Zhetkergen on 05.11.2024.
//

import UIKit

final class CollectionViewModel {
    
    private var images : [UIImage] = []
    
    let weatherNetworkingService = WeatherNetworkingService()
    
    var isFetchingEnded: (() -> Void)?
    
    func fetchImages() {
        weatherNetworkingService.fetchImages { result in
            switch result {
                case .success(let images):
                    self.images = images
                    DispatchQueue.main.async {
                    self.isFetchingEnded?()
                    }
                case .failure:
                    print("Error during fetching images")
                    break
            }
        }
    }
    
    func getImages() -> [UIImage] {
        return images
    }
}
