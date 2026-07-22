//
//  OTPController.swift
//  app.totp
//
//  Created by PropertyShare on 18/06/25.
//

import Foundation
import SwiftOTP



class OTPController{
    
    private init(){
        let list: [User] = keychainDB.getList(forKey: "list")
        accounts.removeAll()
        for i in list{
            accounts.append((i.userId, i.secretKey))
        }
    }
    
    static let instance = OTPController()
    let keychainDB = KeychainDB.shared
    
    var accounts: [(String, String)] = []
//        ("danish.khan+stagingadmin@propertyshare.in", "3QEBKBTWSUHWGD53"),
//        ("harsh.deep@altinvest.ai", "RG7WXICEI3CLB5QZ")
//    ]
    
    
    
    func generateTOTP(secret: String) -> String? {
        guard let data = base32DecodeToData(secret) else { return nil }
        let totp = TOTP(secret: data, digits: 6, timeInterval: 30, algorithm: .sha1)
        return totp?.generate(time: Date())
    }
    
    
    func remainingTime(interval: TimeInterval = 30) -> Int {
        let currentTime = Date().timeIntervalSince1970
        return Int(interval - currentTime.truncatingRemainder(dividingBy: interval))
        
        
        let now = Date().timeIntervalSince1970
        return Int(interval - now.truncatingRemainder(dividingBy: interval))
    }
    
}
