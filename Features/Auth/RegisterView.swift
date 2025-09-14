import SwiftUI

struct RegisterView: View {
    @StateObject var vm = RegisterViewModel()
    let sexes = ["Man", "Woman"]

    var body: some View {
        Form {
            Section(header: Text("Account")) {
                TextField("Username", text: $vm.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $vm.password)
                SecureField("Confirm password", text: $vm.confirmPassword)
                Picker("Sex", selection: $vm.sex) {
                    ForEach(sexes, id: \.self) { Text($0) }
                }
            }

            Section {
                Button("Register") { Task { _ = await vm.register() } }
            }

            if let msg = vm.message {
                Section { Text(msg) }
            }
        }
        .navigationTitle("Register")
    }
}