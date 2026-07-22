//
//  Settings.swift
//  app.totp
//
//  Created by PropertyShare on 18/06/25.
//

import SwiftUI

struct SettingsView: View {
    
    let otpController = OTPController.instance
    
    @State private var nameInput: String = ""
    @State private var keyInput: String = ""
    @ObservedObject var controller = SettingsController()
    @State private var timeRemaining: CGFloat = 30
    let totalTime: CGFloat = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Accounts")
                .font(.title2)
        
            
            List{
                ForEach(controller.userList, id: \.self) { user in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                OTPView(otp: controller.getOTP(secretKey: user.secretKey))
                                Text(user.userId)
                            }
                            Spacer()
                            Button(action: {
                                //                                copyToClipboard(item: user.secretKey)
                                copyToClipboard(item: controller.getOTP(secretKey: user.secretKey))
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle()) // To remove any button styling
                            Button(action: {
                                deleteItem(userId: user.userId, secretKey: user.secretKey)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle()) // To remove any button styling
                        }
                        
                        CountdownBarView(time: CGFloat(controller.getOTPRemainingTime()))
                            .padding(.zero)
                    }
                    }
                
                    .listRowSeparator(.hidden)
                
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .padding(.vertical, 0)
                    .background(RoundedRectangle(cornerRadius: 6).fill(.white))
                    
                
//                  .onDelete(perform: deleteItem)
                }
//            .padding(.zero)
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .frame(minHeight: 200)
            
            HStack {
                TextField("Name", text: $nameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.trailing, 10)
                
                TextField("Secret key", text: $keyInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.trailing, 10)
                
                // Add button
                Button(action: addItem) {
                    Text("Add")
                }
            }
            Spacer()
        }
        .padding()
    }
    
    // Action for adding the entered text to the list
    private func addItem() {
        guard !keyInput.isEmpty else { return }
        controller.addUser(userId: nameInput, secretKey: keyInput)
        nameInput = ""
        keyInput = ""
    }
    
    // Action to delete an item from the list
    private func deleteItem(userId: String, secretKey: String) {
       controller.removeUser(userId: userId, secretKey: secretKey)
    }
    
    private func copyToClipboard(item: String) {
        let textToCopy = "\(item)"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textToCopy, forType: .string)
    }
    
    

}


#Preview {
    SettingsView()
}
