//
//  VINInfo.swift
//  SLOWTRUTH
//
//  Created by Jules on 10/27/23.
//

import Foundation

struct VINResponse: Codable {
    let Results: [VINInfo]
}

struct VINInfo: Codable {
    let Make: String
    let Model: String
    let ModelYear: String
}

func getVINInfo(vin: String) async throws -> VINResponse {
    let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVinValues/\(vin)?format=json"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(VINResponse.self, from: data)
}
