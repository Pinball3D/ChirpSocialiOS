//
//  AccountManager.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 11/6/24.
//

import Foundation

class AccountManager: ObservableObject {
    var accountUtil = AccountUtility()
    @Published var signedIn: Bool = false
    @Published var profile: Profile? = nil
    init() {
        if let user = accountUtil.getUserFromUD() {
            self.signedIn = true
            self.profile = user
        } else {
            self.signedIn = false
        }
    }
    func signOut() {
        accountUtil.signOut()
        self.signedIn = false
        self.profile = nil
    }
    func signIn(username: String, password: String, callback: ((Bool, String?, Profile?) -> Void)?) {
        //do stuff
        ChirpAPI.shared.signIn(username: username, password: password, callback: { [self] success, message, profile in
            if callback != nil {
                callback!(success, message, profile)
            }
            if success {
                accountUtil.setUser(profile!)
                signedIn = true
                self.profile = profile
            }
        })
    }
}

struct AccountUtility {
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "PHPSESSID")
        UserDefaults.standard.removeObject(forKey: "username")
    }
    func getUserFromUD() -> Profile? {
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(Profile.self, from: savedUser) {
                return loadedUser
            }
        }
        return nil
    }
    func setUser(_ user: Profile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "user")
        }
    }
}
