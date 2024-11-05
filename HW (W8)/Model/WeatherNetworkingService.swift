//
//  WeatherNetworkingService.swift
//  HW (W8)
//
//  Created by Amankeldi Zhetkergen on 05.11.2024.
//

import UIKit

final class WeatherNetworkingService {
    var images: [UIImage] = []
    
    let unsplashUrl = "https://api.unsplash.com/photos/random?count=20&client_id=VrJ3q28MCgH3cCsbrlBFPavv4lDt8WNm5rxrZfcAHU0"
    
    func fetchImages(completion: @escaping (Result<[UIImage], Error>)->Void) {
        guard let url = URL(string: unsplashUrl) else {
            completion(.failure("URL is invalid" as! Error))
            return
        }
        let lock = NSLock()
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let photos = try JSONDecoder().decode([WeatherModel].self, from: data)
                let dispatchGroup = DispatchGroup()
                for photo in photos {
                    dispatchGroup.enter()
                    self.downloadImage(from: photo) { result in
                        switch result {
                        case .success(let image):
                            lock.lock()
                            self.images.append(image)
                            lock.unlock()
                        case .failure(let error):
                            print(error)
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(self.images))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func downloadImage(from url: WeatherModel, completion: @escaping (Result<UIImage, Error>)->Void) {
        guard let url = URL(string: url.urls.regular) else {
            completion(.failure("URL is invalid" as! Error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure("cannot get an image" as! Error))
                return
            }
            completion(.success(image))
        }
        task.resume()
    }
}
