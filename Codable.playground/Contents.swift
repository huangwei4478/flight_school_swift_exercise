import UIKit
import Foundation

// Swift automatically synthesizes conformance for Decodable and Encodable
// 1. Codable 写在定义里，不是 Extension 里
// 2. 每一个 Property 都是 Codable 的

/**
 1. Codable is a composite type consisting of the Decodable and Encodable protocols
 2. Swift automatically synthesizes conformance for Decodable and Encodable if a type adopts conformance in its declaration, and each of its stored properties also conforms to that protocols
 3. An Array or Dictionary conforms to Codable if its associated element type is Codable-conforming
 */

struct Plane: Codable {
    var manufacturer: String
    var model: String
    var seats: Int
}

let json = """
 {
   "manufacturer": "Cessna",
   "model": "172 Skyhawk",
   "seats": 4
 }
""".data(using: .utf8)!

let decoder = JSONDecoder()

let plane = try! decoder.decode(Plane.self, from: json)

print(plane.manufacturer)
print(plane.model)
print(plane.seats)

let encoder = JSONEncoder()

// TODO: how to write Data to file?
let reencodedJSON = try! encoder.encode(plane)

print(String(data: reencodedJSON, encoding: .utf8)!)
