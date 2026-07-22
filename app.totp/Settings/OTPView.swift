//
//  OTPView.swift
//  app.totp
//
//  Created by PropertyShare on 25/06/25.
//

import SwiftUI

struct OTPView: View {
    var otp: String

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(otp.enumerated()), id: \.offset) { index, digit in
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .frame(width: 16, height: 24)

                    Text(String(digit))
                        .font(.title2)
                        .fontWeight(.regular)
                        .frame(width: 16, height: 24)
                }
            }
        }
    }
}
