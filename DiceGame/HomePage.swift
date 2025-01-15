//
//  HomePage.swift
//  DiceGame
//
//  Created by Rohit Sankpal on 05/01/25.
//

import SwiftUI

struct HomePage: View {
    @State private var diceNumber = 1
    @State private var isRolling = false
    @State private var changeTheLeft: Bool = false
    @State private var leftRectangleColor: [Color] = Array(repeating: .gray, count: 6)
    @State private var rightRectangleColor: [Color] = Array(repeating: .gray, count: 6)
    @State var isLeftTrack: Bool = true
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Lucy The Racer")
                .font(.title2)
                .fontWeight(.bold)
                .padding(2)
                .fontDesign(.serif)
                .foregroundColor(.purple)
                .padding(.top)
            Spacer()
            
            HStack(alignment: .center) {
                VStack {
                    LeftRowView(
                        changeTheLeft: $changeTheLeft,
                        leftRectangleColor: $leftRectangleColor
                    )
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(width: 50)
                
                VStack {
                    RightRowView(
                        changeTheLeft: $changeTheLeft,
                        rightRectangleColor: $rightRectangleColor
                    )
                    
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 20)
            
            HStack {
                if isLeftTrack {
                    BlikingDotView(isBlinking: true)
                        .padding(.bottom, 10)
                        .padding(.leading ,20)
                    Spacer()
                }
                if !isLeftTrack {
                    Spacer()
                    BlikingDotView(isBlinking: true)
                        .padding(.trailing ,20)
                        .padding(.bottom, 10)
                        
                }
            }
            .frame(height: 50)
            
            RollDice(
                diceNumber: $diceNumber,
                isRolling: $isRolling,
                leftRectangleColor: $leftRectangleColor,
                rightRectangleColor: $rightRectangleColor,
                isLeftTrack: $isLeftTrack
            )
            .frame(width: 100)
            .padding(.top, 20)
        }
        .padding(20)
        .background(Color.black)
    }
}

struct BlikingDotView: View {
    @State var isBlinking: Bool = false
    
    var body: some View {
        Text("Your turn")
            .foregroundColor(.white)
            .font(.headline)
            .fontWeight(.bold)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red)
            )
            .opacity(isBlinking ? 1.0 : 0.3)
            .animation(
                Animation.easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: true),
                value: isBlinking
            )
            .onAppear {
                isBlinking.toggle()
            }
    }
}

struct LeftRowView: View {
    @Binding var changeTheLeft: Bool
    @Binding var leftRectangleColor: [Color]
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(1..<6) { index in
                Rectangle()
                    .fill(leftRectangleColor[index])
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.red.opacity(0.8))
        )
    }
}

struct RightRowView: View {
    @Binding var changeTheLeft: Bool
    @Binding var rightRectangleColor: [Color]
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(1..<6) { index in
                Rectangle()
                    .fill(rightRectangleColor[index])
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.8))
        )
    }
}

struct RollDice: View {
    @Binding var diceNumber: Int
    @Binding var isRolling: Bool
    @Binding var leftRectangleColor: [Color]
    @Binding var rightRectangleColor: [Color]
    @State private var incrementLeftStep = 0
    @State private var incrementRightStep = 0
    @Binding var isLeftTrack: Bool
    @State private var showWinner = false
    @State private var winnerMessage = ""
    @State private var rotation = 0.0
    @State private var bounce = 0.0
    
    var body: some View {
        VStack {
            Button(action: rollDice, label: {
                DiceView(number: diceNumber)
                    .frame(width: 70, height: 70)
                    .rotation3DEffect(
                        .degrees(rotation),
                        axis: (x: Double.random(in: -1...1),
                               y: Double.random(in: -1...1),
                               z: Double.random(in: -1...1))
                    )
                    .offset(y: bounce)
            })
            .padding(.bottom)
            .disabled(showWinner)
            
            // Winner alert
            .alert("Game Over!", isPresented: $showWinner) {
                Button("New Game", role: .cancel) {
                    resetGame()
                }
            } message: {
                Text(winnerMessage)
            }
        }
    }
    
    private func rollDice() {
        isRolling = true
        
        // Animate dice roll
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 5)) {
            bounce = -20
        }
        
        withAnimation(
            .linear(duration: 0.5)
            .repeatCount(5, autoreverses: false)
        ) {
            rotation += 360 * 5
        }
        
        // Reset bounce
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 5).delay(0.5)) {
            bounce = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            diceNumber = Int.random(in: 1...6)
            isRolling = false
            
            if isLeftTrack {
                if diceNumber == 6 {
                    incrementLeftStep += 1
                    // Check if within bounds before updating color
                    if incrementLeftStep <= 5 {
                        leftRectangleColor[6 - incrementLeftStep] = .yellow.opacity(0.8)
                        // Check for winner
                        if incrementLeftStep == 5 {
                            winnerMessage = "Left Player Wins! 🎉"
                            showWinner = true
                        }
                    }
                }
                isLeftTrack.toggle()
            } else {
                if diceNumber == 6 {
                    incrementRightStep += 1
                    // Check if within bounds before updating color
                    if incrementRightStep <= 5 {
                        rightRectangleColor[6 - incrementRightStep] = .yellow.opacity(0.8)
                        // Check for winner
                        if incrementRightStep == 5 {
                            winnerMessage = "Right Player Wins! 🎉"
                            showWinner = true
                        }
                    }
                }
                isLeftTrack.toggle()
            }
        }
    }
    
    private func resetGame() {
        incrementLeftStep = 0
        incrementRightStep = 0
        diceNumber = 1
        leftRectangleColor = Array(repeating: .gray, count: 6)
        rightRectangleColor = Array(repeating: .gray, count: 6)
        isLeftTrack = true
        showWinner = false
        winnerMessage = ""
    }
}

#Preview {
    HomePage()
}
