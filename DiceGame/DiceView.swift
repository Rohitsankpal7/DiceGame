import SwiftUI

struct DiceView: View {
    let number: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red)
                    .shadow(radius: 5)
                
                // Dice dots
                Group {
                    switch number {
                    case 1:
                        DiceDot().position(x: geometry.size.width/2, y: geometry.size.height/2)
                    case 2:
                        Group {
                            DiceDot().position(x: geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: 2*geometry.size.height/3)
                        }
                    case 3:
                        Group {
                            DiceDot().position(x: geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: geometry.size.width/2, y: geometry.size.height/2)
                            DiceDot().position(x: 2*geometry.size.width/3, y: 2*geometry.size.height/3)
                        }
                    case 4:
                        Group {
                            DiceDot().position(x: geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: geometry.size.width/3, y: 2*geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: 2*geometry.size.height/3)
                        }
                    case 5:
                        Group {
                            DiceDot().position(x: geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: geometry.size.width/2, y: geometry.size.height/2)
                            DiceDot().position(x: geometry.size.width/3, y: 2*geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: 2*geometry.size.height/3)
                        }
                    case 6:
                        Group {
                            DiceDot().position(x: geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: geometry.size.height/3)
                            DiceDot().position(x: geometry.size.width/3, y: geometry.size.height/2)
                            DiceDot().position(x: 2*geometry.size.width/3, y: geometry.size.height/2)
                            DiceDot().position(x: geometry.size.width/3, y: 2*geometry.size.height/3)
                            DiceDot().position(x: 2*geometry.size.width/3, y: 2*geometry.size.height/3)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct DiceDot: View {
    var body: some View {
        Circle()
            .fill(Color.black)
            .frame(width: 10, height: 10)
    }
} 
