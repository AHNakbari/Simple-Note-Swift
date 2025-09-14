import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject var vm = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Let’s login").font(.title).bold()
            Text("And notes your idea").foregroundStyle(.secondary)

            TextField("Username", text: $vm.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            Button(action: { Task { if await vm.login() { session.isAuthenticated = true } } }) {
                Text("Login").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            if let e = vm.error { Text(e).foregroundStyle(.red) }

            NavigationLink("Don’t have an account? Register here") {
                RegisterView()
            }
            .padding(.top, 8)
        }
        .padding()
        .navigationTitle("Login")
    }
}