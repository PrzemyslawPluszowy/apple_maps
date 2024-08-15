import SwiftUI

struct SwiftUIView: View {
    var body: some View {
       ZStack {
            Color.red
            Text("Hello, World!")
                .font(.title)
                .foregroundColor(.white)
       }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}