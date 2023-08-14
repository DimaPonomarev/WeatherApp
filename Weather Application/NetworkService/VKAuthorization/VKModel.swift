//
//  VkModel.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 24.06.2023.
//

import Foundation

struct APIVKontakteManager: Decodable {
    let response: ProfileResponse
}

struct ProfileResponse : Decodable {
    let id: Int
    let photo200: String
}
