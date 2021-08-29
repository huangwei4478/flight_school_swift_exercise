import UIKit
import Foundation
/**
 {
   "points": ["KSQL", "KWVI"],
   "KSQL": {
     "code": "KSQL",
     "name": "San Carlos Airport"
   },
   "KWVI": {
     "code": "KWVI",
     "name": "Watsonville Municipal Airport"
    }
}
 */

// 这种这么奇怪的结构也能解析？
struct Route: Decodable {
    struct Airport: Decodable {
        var code: String
        
        var name: String
    }
    
    var points: [Airport]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let codes = try container.decode([String].self,
                                         forKey: .points)
        
        self.points = try codes.map({ code in
            let key = CodingKeys(stringValue: code)!
            return try container.decode(Airport.self, forKey: key)
        })
    }
    
    // 用 Struct 也能做 CodingKey？
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        
        var intValue: Int? {
            return nil
        }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        static let points = CodingKeys(stringValue: "points")!
    }
}

// WTF is this????

enum Either<T, U> {
    case left(T)
    case right(U)
}

extension Either: Decodable where T: Decodable,
                                  U: Decodable {
    init(from decoder: Decoder) throws {
        if let value = try? T(from: decoder) {
            self = .left(value)
        } else if let value = try? U(from: decoder) {
            self = .right(value)
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode \(T.self) or \(U.self)")
            throw DecodingError.dataCorrupted(context)
        }
    }
}

// Decoding Arbitrary Type

// 做一个 Type-Erasure
//struct Report: Decodable {
//    var title: String
//
//    var body: String
//
//    var metadata: [String: AnyCodable]
//}


