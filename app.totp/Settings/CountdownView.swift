//
//  CountdownView.swift
//  app.totp
//
//  Created by PropertyShare on 25/06/25.
//
import SwiftUI

struct CountdownBarView: View {
    @State private var timeRemaining: CGFloat = 10
    init(time: CGFloat) {
//        timeRemaining = time
        _timeRemaining = State(initialValue: time)
    }
    let totalTime: CGFloat = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(height: 3)
                        .foregroundColor(Color.gray.opacity(0.3))

                    Capsule()
                        .frame(width: geometry.size.width * (timeRemaining / totalTime), height: 3)
                        .foregroundColor(.blue)
                        .animation(.linear(duration: 1), value: timeRemaining)
                }
            }
            .frame(height: 10)

//            Text("Time remaining: \(Int(timeRemaining)) seconds")
//                .font(.headline)
            
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            else if timeRemaining == 0{
                timeRemaining = 30
            }
        }
    }
}



#Preview {
    CountdownBarView(time: 20)
}
