import Foundation

// Your imports remain the same

struct Chirp: Identifiable, Codable {
    let id: Int
    let content: String
    let author: User
    let timestamp: Date
    var likes: Int
    var replies: Int
    var rechirps: Int
    var isLiked: Bool
    var isRechirped: Bool
    var attachments: [Attachment]?
    var poll: Poll?
    var parentChirp: Chirp?
    
    // Your properties and methods remain the same
    
    struct User: Identifiable, Codable {
        let id: Int
        let username: String
        let displayName: String
        let profilePicture: String
        
        // Your properties and methods remain the same
    }
    
    struct Attachment: Identifiable, Codable {
        let id: Int
        let type: AttachmentType
        let url: String
        
        // Your properties and methods remain the same
        
        enum AttachmentType: String, Codable {
            case image
            case video
            // Add other attachment types as needed
        }
    }
    
    struct Poll: Identifiable, Codable {
        let id: Int
        let question: String
        var options: [PollOption]
        let expirationDate: Date?
        
        // Your properties and methods remain the same
        
        struct PollOption: Identifiable, Codable {
            let id: Int
            let text: String
            var votes: Int
            
            // Your properties and methods remain the same
        }
    }
}

// End of file. No additional code.