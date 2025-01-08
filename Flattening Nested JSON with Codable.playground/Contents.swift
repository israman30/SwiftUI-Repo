import UIKit

// Source: https://www.donnywals.com/flattening-a-nested-json-response-into-a-single-struct-with-codable/
/**
 {
   "id": 10,
   "contact_info": {
     "email": "test@test.com"
   },
   "preferences": {
     "contact": {
       "newsletter": true
     }
   }
 }
 */

struct User: Decodable {
    let id: Int
    let email: String
    let isSubscribedToNewsletter: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, preferences
        case contactInfo = "contact_info"
    }
    
    struct ContactInfo: Decodable {
        let email: String
    }
    
    struct Preferences: Decodable {
        let contact: ContactPreferences
        
        struct ContactPreferences: Decodable {
            let newsletter: Bool
        }
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let contactInfo = try container.decode(ContactInfo.self, forKey: .contactInfo)
        let preferences = try container.decode(Preferences.self, forKey: .preferences)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = contactInfo.email
        self.isSubscribedToNewsletter = preferences.contact.newsletter
    }
}

