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
    func get(_ type: getType, offset: Int, userId: Int? = nil, chirpId: Int? = nil, callback: @escaping (_ response: [Chirp], _ success: Bool, _ errorMessage: String?) -> Void) {
        let headers: HTTPHeaders = [ "Cookie": "PHPSESSID="+self.getSessionToken(), "Content-Type": "application/json" ]
        switch type {
        case .chirps:
            AF.request("https://beta.chirpsocial.net/fetch_chirps.php?offset=\(offset)", headers: headers).responseDecodable(of: [Chirp].self) { response in
                switch response.result {
                case .success(let chirps):
                    callback(chirps, true, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    callback([], false, "An error occurred. Maybe Chirpie needs to sleep. Try again later.")
                }
            }
        case .replies:
            if (chirpId == nil) {
                print("no chirp provided for reply fetch")
                callback([], false, "An internal error occoured.")
                return
            }
            AF.request("https://beta.chirpsocial.net/chirp/fetch_replies.php?offset=\(offset)&for=\(chirpId!)", headers: headers).responseDecodable(of: [Chirp].self) { response in
                switch response.result {
                case .success(let replies):
                    callback(replies, true, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    callback([], false, "An error occurred. Maybe Chirpie needs to sleep. Try again later.")
                }
            }
        case .userReplies:
            if (userId == nil) {
                print("no chirp provided for user reply fetch")
                callback([], false, "An internal error occoured.")
                return
            }
            AF.request("https://beta.chirpsocial.net/user/fetch_replies.php?offset=0&user=\(userId!)", headers: headers).responseDecodable(of: [Chirp].self) { response in
                switch response.result {
                case .success(let replies):
                    callback(replies, true, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    callback([], false, "An error occurred. Maybe Chirpie needs to sleep. Try again later.")
                }
            }
        case .userChirps:
            AF.request("https://beta.chirpsocial.net/user/fetch_chirps.php?offset=0&user=\(userId!)", headers: headers).responseDecodable(of: [Chirp].self) { response in
                switch response.result {
                case .success(let chirps):
                    callback(chirps, true, nil)
                case .failure(let error):
                    print("Error: \(error)")
                    callback([], false, "An error occurred. Maybe Chirpie needs to sleep. Try again later.")
                }
            }
        case .userMedia:
            print("todo")
            callback([], false, "This feature is not yet implemented.")
        
        case .userLikes:
            print("todo")
            callback([], false, "This feature is not yet implemented.")
        }
    }
    
    func signIn(username: String, password: String, callback: @escaping (_ success: Bool, _ message: String?) -> Void) {
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
                callback(false, "An error occoured while logging in. Please try again later or check your username and password.")
                return
            } else if let data = data {
                let str = String(data: data, encoding: .utf8)
                print(str ?? "")
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]
                print("hi")
                if json?["error"] == nil {
                    
                } else if json?["error"] as! String == "Please fill in both fields." {
                    print("hi2")
                    callback(false, "Please fill in both fields.")
                    return
                } else {
                    callback(false, "An error occoured while logging in. Please try again later or check your username and password.")
                    return
                }
                print("hi3")
                var done = false
                let cookies = AF.session.configuration.httpCookieStorage?.cookies(for: URL(string: "https://beta.chirpsocial.net/signin/signin.php")!)
                cookies?.forEach {
                    if $0.name == "PHPSESSID" {
                        print($0.value)
                        UserDefaults.standard.set($0.value, forKey: "PHPSESSID")
                        callback(true, nil)
                        done = true
                        return
                    }
                }
                if !done {
                    callback(false, "An error occoured while logging in. Please try again later or check your username and password.")
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
    func getProfile(username: String, callback: @escaping (_ success: Bool, _ errorMessage: String?, _ profile: Profile?) -> Void) {
        var profile = Profile(id: 0, name: "", username: "", bannerPic: "", profilePic: "", followingCount: 0, followersCount: 0, joinedDate: "", bio: "")
        AF.request("https://beta.chirpsocial.net/user/?id="+username).response { data in
            switch data.result {
            case .success(let res):
                do {
                    let html = try SwiftSoup.parse(String(data: res!, encoding: .utf8)!)
                    let accInfoDiv = try html.select(".accountInfo")[0]
                    let acc = try html.select(".account")[0]
                    let accStats = try html.select("#accountStats")[0]
                    profile.profilePic = try accInfoDiv.children()[0].children()[0].attr("src")
                    profile.bannerPic = try html.select(".userBanner")[0].attr("src")
                    profile.name = try accInfoDiv.children()[0].children()[1].children()[0].text().trimmingCharacters(in: .whitespaces)
                    profile.username = try accInfoDiv.children()[0].children()[1].children()[1].text()
                    profile.bio = try acc.children()[1].text().trimmingCharacters(in: .whitespaces)
                    profile.followingCount = Int(try accStats.children()[0].text().replacingOccurrences(of: " following", with: "")) ?? 0
                    profile.followersCount = Int(try accStats.children()[1].text().replacingOccurrences(of: " followers", with: "")) ?? 0
                    profile.joinedDate = try accStats.children()[2].text().trimmingCharacters(in: .whitespacesAndNewlines)
                    let script = html.body()?.children().last()
                    for line in try script!.html().split(separator: "\r\n") {
                        if line.contains("/user/fetch_chirps.php?offset=") {
                            profile.id = Int(line.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "fetch(`/user/fetch_chirps.php?offset=${offset}&user=", with: "").replacingOccurrences(of: "`)", with: "")) ?? 0
                        }
                    }
                    callback(true, nil, profile)
                } catch {
                    callback(false, "An internal error occoured.", nil)
                }
            case .failure(_):
                callback(false, "An internal error occoured.", nil)
            }
        }
    }
}

struct interation: Encodable {
    let action: String
    let chirpId: Int
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
