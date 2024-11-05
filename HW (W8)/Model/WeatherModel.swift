//
//  WeatherModel.swift
//  HW (W8)
//
//  Created by Amankeldi Zhetkergen on 05.11.2024.
//
import Foundation

struct WeatherModel: Codable {
    let urls: imageURL
}
struct imageURL: Codable {
    let regular: String
}
