import SwiftUI

enum CodingKeys: String, CodingKey {
    case id
    case name
    case address
    case email
}

struct User: Codable {
    let id: String
    let name: String
    let address: String
    let email: String
    
    init(id: String, name: String, address: String, email: String) {
        self.id = id
        self.name = name
        self.address = address
        self.email = email
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(email, forKey: .email)
    }
}

let user = User(id: "aaabbbccc", name: "John Doe", address: "hi house", email: "jdoe@mail.oom")
