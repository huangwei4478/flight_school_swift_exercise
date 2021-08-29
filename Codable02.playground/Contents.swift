import UIKit

/**
 Codable：处理各种不如意的事情
 
 Recap:
 1. 不要用手写 encoder & decoder
 2. private CodingKeys 枚举，来解决名称映射问题
 3. computed properties 是个很好的工具
 
 */

let json = """
 {
     "aircraft": {
         "identification": "NA12345",
         "color": "Blue/White"
     },
     "route": ["KTTD", "KHIO"],
     "flight_rules": "VFR",
     "departure_time": {
         "proposed": "2018-04-20T14:15:00-07:00",
         "actual": "2018-04-20T14:20:00-07:00"
     },
     "remarks": null
 }
""".data(using: .utf8)!

struct Aircraft: Decodable {
    var identification: String
    var color: String
}

enum FlightRules: String, Decodable {
    case visual = "VFR"
    
    case instrument = "IFR"
}

struct FlightPlan: Decodable {
    var aircraft: Aircraft
    
    var route: [String]
    
    var flightRules: FlightRules
    
    private var departureDates: [String: Date]
    
    var proposedDepartureDate: Date? {
        return departureDates["proposed"]
    }
    
    var actualDepartureDate: Date? {
        return departureDates["actual"]
    }
    
    var remarks: String?
    
    private enum CodingKeys: String, CodingKey {
        case aircraft
        case flightRules = "flight_rules"
        case route
        case departureDates = "departure_time"
        case remarks
    }
}

var decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601     // 日期的转换，其实这里都囊括了


let plan = try! decoder.decode(FlightPlan.self, from: json)
print(plan.aircraft.identification)
print(plan.actualDepartureDate!)
