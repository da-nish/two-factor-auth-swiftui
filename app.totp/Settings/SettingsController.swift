//
//  SettingController.swift
//  app.totp
//
//  Created by PropertyShare on 25/06/25.
//

import Foundation


class SettingsController: ObservableObject{
    
    let keychainDB = KeychainDB.shared;
    @Published var userList: [User] = []
    
    private let forKey = "list"

    
    init(){
        userList = keychainDB.getList(forKey: forKey)
    }
    
    func addUser(userId: String, secretKey: String){
        keychainDB.addItem(User(userId: userId, secretKey: secretKey), forKey: forKey)
        loadList()
    }
    
    func removeUser(userId: String, secretKey: String){
        keychainDB.deleteItem(User(userId: userId, secretKey: secretKey), forKey: forKey)
        loadList()
    }
    
    
    func loadList(){
        userList = keychainDB.getList(forKey: forKey)
    }
    
    
    func getOTP(secretKey: String) -> String{
        return OTPController.instance.generateTOTP(secret: secretKey) ?? "-"
    }
    
    func getOTPRemainingTime() -> Int{
        let time = OTPController.instance.remainingTime()
        return time
    }
}



struct User: Codable, Equatable, Hashable {
    let userId: String
    let secretKey: String
}


struct OTPViewModel: Codable, Equatable, Hashable {
    let userId: String
    let secretKey: String
}
