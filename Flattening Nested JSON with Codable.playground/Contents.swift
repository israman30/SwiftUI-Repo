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
    
    enum Outerkeys: String, CodingKey {
        case id, preferences
        case contactInfo = "contact_info"
    }
    
    enum ContactKey: String, CodingKey {
        case email
    }
    
    enum PreferencesKey: String, CodingKey {
        case contact
    }
    
    enum ContactPreferencesKey: String, CodingKey {
        case newsletter
    }
    
    enum CodingKeys: CodingKey {
        case id
        case contactInfo
        case isSubscribedToNewsletter
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: Outerkeys.self)
        let contactContainer = try outerContainer.nestedContainer(keyedBy: ContactKey.self, forKey: .contactInfo)
        let preferenceContainer = try outerContainer.nestedContainer(keyedBy: PreferencesKey.self, forKey: .preferences)
        let contactPreferenceContainer = try preferenceContainer.nestedContainer(keyedBy: ContactPreferencesKey.self, forKey: .contact)
        
        self.id = try outerContainer.decode(Int.self, forKey: .id)
        self.email = try contactContainer.decode(String.self, forKey: .email)
        self.isSubscribedToNewsletter = try contactPreferenceContainer.decode(Bool.self, forKey: .newsletter)
    }
}

