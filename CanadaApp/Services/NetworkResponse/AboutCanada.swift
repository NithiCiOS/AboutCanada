//
//  AboutCanada.swift
//  CanadaApp
//
//  Created by CVN on 06/02/21.
//

import Foundation

// MARK: - AboutCanada
struct AboutCanada: Codable {
    let about: String?
    let rows: [CanadaDetail]?
    enum CodingKeys: String, CodingKey {
        case about = "title"
        case rows
    }
}

// MARK: - Row
struct CanadaDetail: Codable {
    let title, rowDescription: String?
    let imageHref: String?

    enum CodingKeys: String, CodingKey {
        case title
        case rowDescription = "description"
        case imageHref
    }
}
