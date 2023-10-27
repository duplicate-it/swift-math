import SwiftUI

var previousScore: [Int] = []

@main
struct SwiftMath: App {
    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "number")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 150)
                Text("Swift Math")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                    .padding()
                NavigationLink(destination: ContentView()) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.teal)
                        .frame(width: 75, height: 75)
                }.padding()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView: View {
    @State private var playerScore: Int = 0
    @State private var playerTime: Double = 10
    @State private var currentEquation: (String, Bool, Int) = ("", false, 0)
    @State private var gameOver: Bool = false
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect() 
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: playerTime, total: 10)
                    .progressViewStyle(.linear)
                    .onReceive(timer) { _ in
                        if playerTime > 0 {
                             playerTime -= 0.01
                        } else {
                            timer.upstream.connect().cancel()
                            previousScore.append(playerScore)
                            gameOver = true
                        }
                    }
                Text(String(playerScore))
                    .font(.title)
                Spacer()
                Text(currentEquation.0)
                    .font(.system(size: 56))
                Spacer()
                HStack {
                    Button(action: {checkAnswer(true)}) {
                        Image(systemName: "checkmark.square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.mint)
                            .frame(width: 150, height: 150)
                    }
                    .padding()
                    Spacer()
                    Button(action: {checkAnswer(false)}) {
                        Image(systemName: "xmark.square.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.pink)
                            .frame(width: 150, height: 150)
                    }.padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                generateEquation()
            }
            .navigationDestination(isPresented: $gameOver) {
                EndView()
            }
        }
    }
    
    func generateEquation() {
        let isTrue = Bool.random()
        let operation = Int.random(in: 0...3)
        let firstInt = Int.random(in: 1...50)
        let secondInt = Int.random(in: 1...50)
        let falseInt = Int.random(in: 1...10) * 2
        
        if operation == 0 { 
            // Addition 
            currentEquation = ("\(firstInt) + \(secondInt) = \(isTrue ? firstInt + secondInt : firstInt + secondInt + falseInt)", isTrue, 0)
        } else if operation == 1 {
            // Subtraction
            currentEquation = ("\(isTrue ? firstInt + secondInt : firstInt + secondInt + falseInt) - \(firstInt) = \(secondInt)", isTrue, 1)
        } else if operation == 2 {
            // Multiplication 
            currentEquation = ("\(firstInt) × \(secondInt) = \(isTrue ? firstInt * secondInt : firstInt * secondInt + falseInt)", isTrue, 2)
        } else if operation == 3 {
            // Division 
            currentEquation = ("\(isTrue ? firstInt * secondInt : firstInt * secondInt + falseInt) ÷ \(firstInt) = \(secondInt)", isTrue, 3)
        }
    }
    
    func checkAnswer(_ answer: Bool) {
        if answer == currentEquation.1 {
            playerScore += 1
            generateEquation()
            playerTime = 10
        } else {
            previousScore.append(playerScore)
            gameOver = true
        }
    }
}

struct EndView: View {
    @State private var playerScore: Optional<Int> = Optional(0)
    @State private var highScore: Optional<Int> = Optional(0)
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("score")
                    .font(.largeTitle)
                    .padding()
                Text(String(playerScore ?? 0))
                    .font(.system(size: 64))
                    .foregroundColor(.teal)
                    .padding()
                Text("highscore")
                    .font(.largeTitle)
                    .padding()
                Text(String(highScore ?? 0))
                    .font(.system(size: 64))
                    .foregroundColor(.mint)
                    .padding()
                HStack {
                    NavigationLink(destination: StartView()) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }.padding()
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "gobackward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }.padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                playerScore = previousScore.last
                highScore = previousScore.max()
            }
        }
    }
}
