/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

extension Chat {
  struct JoinSessionView: SwiftUI.View {
    @StateObject private var sessionCoordinator = Chat.SessionCoordinator()

    var body: some SwiftUI.View {
      VStack(spacing: 24) {
        Image(systemName: "network")
          .resizable()
          .frame(width: 100, height: 100)

        NavigationLink(
          destination: sessionCoordinator.browser?.navigationBarHidden(true),
          tag: .browser,
          selection: destination
        ) {
          Button(
            action: sessionCoordinator.join,
            label: {
              Label(
                "Join a Chat Session",
                systemImage: "arrow.up.right.and.arrow.down.left.rectangle"
              )
            }
          )
          .buttonStyle(MultipeerButtonStyle())
        }

        Button(
          action: sessionCoordinator.host,
          label: {
            Label("Host a Chat Session", systemImage: "plus.circle")
          }
        )
        .buttonStyle(MultipeerButtonStyle())

        NavigationLink(
          destination:
            Chat.View()
            .environmentObject(sessionCoordinator),
          tag: .chat,
          selection: destination
        ) { }
      }
      .navigationTitle("Chat")
    }
  }
}

private extension Chat.JoinSessionView {
  struct MultipeerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .padding()
        .font(.headline)
        .background(configuration.isPressed ? Color("rw-dark") : Color.accentColor)
        .cornerRadius(9.0)
        .foregroundColor(.white)
    }
  }

  enum Destination {
    case browser, chat
  }

  var destination: Binding<Destination?> {
    .constant(
      sessionCoordinator.browser != nil
        ? .browser
        : sessionCoordinator.connectedToChat
        ? .chat
        : nil
    )
  }
}

struct JoinSessionView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      Chat.JoinSessionView()
    }
  }
}
