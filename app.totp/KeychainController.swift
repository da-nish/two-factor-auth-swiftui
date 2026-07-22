////
////  KeychainController.swift
////  app.totp
////
////  Created by PropertyShare on 18/06/25.
////
//
//import Foundation
//
//
//class KeychainController{
//    
//    static let instance = KeychainController()
//    
//    private init(){
//        let service = "com.example.myapp"
//        let account = "user@example.com"
//    }
//    
//    private let service = "a"
//    private let account = "_a"
//
//    
//    func readData(){
//        // Read (Retrieve Data)
//        if let retrievedData = KeychainDB.getKeychainItem(service: service, account: account),
//           let retrievedPassword = String(data: retrievedData, encoding: .utf8) {
//            print("Retrieved Password: \(retrievedPassword)")
//        }
//    }
//        
//    func createData(data: Data){
//        // Create (Add/Save Data)
//        let addSuccess = KeychainDB.addKeychainItem(service: service, account: account, data: data)
//        print("Add Success: \(addSuccess)")
//    }
//    
//    func deleteData(){
//        // Delete
//        let deleteSuccess = KeychainDB.deleteKeychainItem(service: service, account: account)
//        print("Delete Success: \(deleteSuccess)")
//        
//    }
//}
