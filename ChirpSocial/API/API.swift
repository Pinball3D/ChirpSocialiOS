//
//  API.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//
import Alamofire
import Foundation
import SwiftSoup

class ChirpAPI {
    static let shared = ChirpAPI()
    func get(_ type: getType, offset: Int, userId: Int? = nil, chirpId: Int? = nil, callback: @escaping (_ response: [Chirp], _ success: Bool, _ errorMessage: String?) -> Void) {
        let headers: HTTPHeaders = [ "Cookie": "PHPSESSID="+self.getSessionToken(), "Content-Type": "application/json" ]
        let fetchType = fetchType(type)
        let id = (userId != nil ? userId! : (chirpId != nil ? chirpId! : -1))
        let parentType = fetchParentType(type)
        let idQuery = id != -1 ? (parentType == "/chirp" ? "&for=\(id)" : "&user=\(id)") : ""
        print("[CHIRP API] https://beta.chirpsocial.net\(parentType)/fetch_\(fetchType).php?offset=\(offset)\(idQuery)")
        AF.request("https://beta.chirpsocial.net\(parentType)/fetch_\(fetchType).php?offset=\(offset)\(idQuery)", headers: headers).responseDecodable(of: [Chirp].self) { response in
            switch response.result {
            case .success(let chirps):
                if type == .userReplies {
                    print("[API] USER REPLIES: \(chirps)")
                }
                print("[API] USER REPLIES: \(chirps)")
                callback(chirps, true, nil)
            case .failure(let error):
                print("Error: \(error)")
                callback([], false, "An error occurred. Maybe Chirpie needs to sleep. Try again later.")
            }
        }
    }
    func getPost(_ chirpId: Int, callback: @escaping (_ response: Chirp?, _ success: Bool, _ errorMessage: String?) -> Void) {
        var chirp = Chirp(id: chirpId, user: 0, type: "post", chirp: "", parent: nil, timestamp: 0, via: nil, username: "", name: "", profilePic: "", isVerified: false, likeCount: 0, rechirpCount: 0, replyCount: 0, likedByCurrentUser: false, rechirpedByCurrentUser: false)
        let headers: HTTPHeaders = [
            "Cookie": "PHPSESSID="+self.getSessionToken(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        AF.request("https://beta.chirpsocial.net/chirp/?id="+String(chirpId), headers: headers).response { data in
            switch data.result {
            case .success(let res):
                do {
                    let html = try SwiftSoup.parse(String(data: res!, encoding: .utf8)!)
                    let chirpDIV = try html.select("#"+String(chirpId)).first!
                    
                    callback(chirp, true, nil)
                } catch {
                    callback(nil, false, "An internal error occoured.")
                }
            case .failure(_):
                callback(nil, false, "An internal error occoured.")
            }
        }
    }
    func signIn(username: String, password: String, callback: @escaping (_ success: Bool, _ message: String?, _ profile: User?) -> Void) {
        let data = NSMutableData(data: ("username=\(username)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!.data(using: .utf8)!)
        data.append(("&pWord=\(password)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!.data(using: .utf8)!)

        let url = URL(string: "https://beta.chirpsocial.net/signin/signin.php")!
        let headers = [
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "accept-language": "en-US,en;q=0.9",
            "cache-control": "max-age=0",
            "content-type": "application/x-www-form-urlencoded",
            "dnt": "1",
            "origin": "https://beta.chirpsocial.net",
            "priority": "u=0, i",
            "referer": "https://beta.chirpsocial.net/signin/",
            "sec-ch-ua": "\"Chromium\";v=\"127\", \"Not)A;Brand\";v=\"99\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"macOS\"",
            "sec-fetch-dest": "document",
            "sec-fetch-mode": "navigate",
            "sec-fetch-site": "same-origin",
            "sec-fetch-user": "?1",
            "upgrade-insecure-requests": "1",
            "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                callback(false, "An error occoured while logging in.", nil)
                return
            } else if let data = data {
                let str = String(data: data, encoding: .utf8)
                print(str ?? "")
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]
                print("hi")
                if json?["error"] == nil {
                    do {
                        let html = try SwiftSoup.parse(String(data: data, encoding: .utf8)!)
                        let settingsWrapper = try html.select("#settingsButtonWrapper")[0]
                        let username = try settingsWrapper.children()[1].children()[1].text().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "@", with: "")
                        let cookies = AF.session.configuration.httpCookieStorage?.cookies(for: URL(string: "https://beta.chirpsocial.net/signin/signin.php")!)
                        cookies?.forEach {
                            if $0.name == "PHPSESSID" {
                                print($0.value)
                                UserDefaults.standard.set($0.value, forKey: "PHPSESSID")
                                self.getUser(username: username) { success, errorMessage, profile in
                                    if success {
                                        callback(true, nil, profile)
                                    }
                                    return
                                }
                            }
                        }
                    } catch {
                        callback(false, "An error occoured while logging in.", nil)
                    }
                } else if json?["error"] as! String == "Please fill in both fields." {
                    print("hi2")
                    callback(false, "Please fill in both fields.", nil)
                    return
                } else {
                    callback(false, "An error occoured while logging in.", nil)
                    return
                }
            }
        }
        task.resume()
    }
    
    func getSessionToken() -> String {
        print(UserDefaults.standard.string(forKey: "PHPSESSID") ?? "")
        return UserDefaults.standard.string(forKey: "PHPSESSID") ?? ""
    }
    func interact(action: InteractionType, chirp: Chirp, callback: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let headers: HTTPHeaders = [ "Cookie": "PHPSESSID="+self.getSessionToken(), "Content-Type": "application/json" ]
        let param = interation(action: action.rawValue, chirpId: chirp.id)
        AF.request("https://beta.chirpsocial.net/interact_chirp.php", method: .post, parameters: param, encoder: .json, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    print(json)
                    if json["success"] as? Bool == true {
                        callback(true, nil)
                    } else {
                        callback(false, json["error"] as? String)
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
                callback(false, "An error occoured while trying to interact with this post. Try again later.")
                return
            }
            
        }
    }
    func userInteract(action: UserInteractionType, user: User, callback: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let headers: HTTPHeaders = [ "Cookie": "PHPSESSID="+self.getSessionToken(), "Content-Type": "application/json" ]
        let param = userInteration(action: action.rawValue, userId: user.id)
        AF.request("https://beta.chirpsocial.net/interact_user.php", method: .post, parameters: param, encoder: .json, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    print(json)
                    if json["success"] as? Bool == true {
                        callback(true, nil)
                    } else {
                        callback(false, json["error"] as? String)
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
                callback(false, "An error occoured while trying to interact with this post. Try again later.")
                return
            }
            
        }
    }
    func chirp(content: String, parent: Int? = nil) {
        let parameters: Parameters = [
            "chirpComposeText": content
        ]
        let headers: HTTPHeaders = [
            "Cookie": "PHPSESSID="+self.getSessionToken(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        AF.request("https://beta.chirpsocial.net/\(parent==nil ? "compose":"chirp")/submit.php\(parent==nil ? "":"?id=\(parent!)")", method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    print("JSON: \(json)")
                    // Handle the JSON as a dictionary
                } else if let jsonArray = value as? [[String: Any]] {
                    print("JSON Array: \(jsonArray)")
                    // Handle the JSON as an array of dictionaries
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func search(searchTerm: String, callback: @escaping (_ success: Bool, _ errorMessage: String?, _ results: [SearchChirp]) -> Void) {
        print("SEARCHING FOR: \(searchTerm)")
        AF.request("https://beta.chirpsocial.net/discover/search.php?query=\(searchTerm)").responseDecodable(of: [SearchChirp].self) { response in
            switch response.result {
            case .success(let chirps):
                callback(true, nil, chirps)
            case .failure(let error):
                print("Error: \(error)")
                callback(false, "An error occurred. Maybe Chirpie needs to sleep. Try again later.", [])
            }
        }
    }
    func getUser(username: String, callback: @escaping (_ success: Bool, _ errorMessage: String?, _ profile: User?) -> Void) {
        var profile = User(id: 0, name: "", username: "", bannerPic: "", profilePic: "", followingCount: 0, followersCount: 0, joinedDate: "", bio: "")
        let headers: HTTPHeaders = [
            "Cookie": "PHPSESSID="+self.getSessionToken(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        AF.request("https://beta.chirpsocial.net/user/?id="+username, headers: headers).response { data in
            switch data.result {
            case .success(let res):
                do {
                    let html = try SwiftSoup.parse(String(data: res!, encoding: .utf8)!)
                    if try html.select(".accountInfo").count == 0 {
                        callback(false, "User not found", nil)
                        return
                    }
                    if try html.select(".accountInfo").count < 1 {
                        callback(false, "User not found", nil)
                        return
                    }
                    let accInfoDiv = try html.select(".accountInfo")[0]
                    if try html.select(".account").count < 1 {
                        callback(false, "User not found", nil)
                        return
                    }
                    let acc = try html.select(".account")[0]
                    let accStats = try html.select("#accountStats")[0]
                    profile.profilePic = try accInfoDiv.children()[0].children()[0].attr("src")
                    profile.bannerPic = try html.select(".userBanner")[0].attr("src")
                    profile.name = try accInfoDiv.children()[0].children()[1].children()[0].text().trimmingCharacters(in: .whitespaces)
                    if try html.getElementsByClass("followsYouBadge").count > 0 {
                        profile.followsCurrentUser = true
                        try html.getElementsByClass("followsYouBadge").first()?.remove()
                    }
                    profile.username = try accInfoDiv.children()[0].children()[1].children()[1].text().replacingOccurrences(of: "@", with: "")
                    profile.bio = try acc.children()[1].text().trimmingCharacters(in: .whitespaces)
                    profile.followingCount = Int(try accStats.children()[0].text().replacingOccurrences(of: " following", with: "")) ?? 0
                    profile.followersCount = Int(try accStats.children()[1].text().replacingOccurrences(of: " followers", with: "")) ?? 0
                    profile.joinedDate = try accStats.children()[2].text().trimmingCharacters(in: .whitespacesAndNewlines)
                    if accInfoDiv.children()[1].children().count > 1 {
                        profile.isCurrentUserFollowing = (try accInfoDiv.children()[1].children()[1].attr("style") == "")
                    }
                    let postsElement = try html.select("#posts")[0]
                    profile.id = Int(try postsElement.attr("data-user-id")) ?? -1
                    callback(true, nil, profile)
                } catch {
                    callback(false, "An internal error occoured.", nil)
                }
            case .failure(_):
                callback(false, "An internal error occoured.", nil)
            }
        }
    }
    func getUsernameFromSessionId(sessionId: String, callback: @escaping (_ success: Bool, _ errorMessage: String?, _ username: String?) -> Void) {
        let headers: HTTPHeaders = ["Cookie": "PHPSESSID="+self.getSessionToken()]
        AF.request("https://beta.chirpsocial.net/", headers: headers).response { data in
            switch data.result {
            case .success(let response):
                do {
                    print(String(data: response!, encoding: .utf8)!)
                    let html = try SwiftSoup.parse(String(data: response!, encoding: .utf8)!)
                    if try html.select(".accountInfo").count >= 1 {
                        let accInfoDiv = try html.select(".accountInfo")[0]
                        let username = try accInfoDiv.children()[0].children()[1].children()[1].text().replacingOccurrences(of: "@", with: "")
                        callback(true, nil, username)
                        return
                    }
                    callback(false, "An internal error occoured.", nil)
                } catch {
                    callback(false, "An internal error occoured.", nil)
                }
            case .failure(_):
                callback(false, "An internal error occoured.", nil)
            }
        }
    }
    func sendAPNSTokenToDiscord(token: String, username: String?, callback: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let parameters = username == nil ? "{\"deviceToken\": \""+token+"\"}" : "{\"deviceToken\": \""+token+"\",\"username\": \""+username!+"\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://chirpnotifs.smileyzone.net/register/")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    func fetchType(_ _for: getType) -> String {
        switch (_for) {
            
        case .chirps: return "chirps"
        case .replies: return "replies"
        case .userReplies: return "replies"
        case .userChirps: return "chirps"
        case .userMedia: return "media"
        case .userLikes:return "likes"
        }
    }
    func fetchParentType(_ _for: getType) -> String {
        switch (_for) {
        case .chirps: return ""
        case .replies: return "/chirp"
        case .userReplies: return "/user/replies"
        case .userChirps: return "/user"
        case .userMedia: return "/user/media"
        case .userLikes:return "/user/likes"
        }
    }
}

struct interation: Encodable {
    let action: String
    let chirpId: Int
}
struct userInteration: Encodable {
    let action: String
    let userId: Int
}

struct InterationResponse {
    let action: String
    let status: Bool
    let count: Int
    let success: Bool
}

struct ChirpResponse {
    let success: Bool
    let id: Bool
}

enum getType {
    case chirps
    case replies
    case userReplies
    case userChirps
    case userMedia
    case userLikes
}
enum UserInteractionType: String {
    case follow = "follow"
    case unfolllow = "unfollow"
}

struct NotifToken: Encodable {
    let token: String
    var username: String? = nil
}
