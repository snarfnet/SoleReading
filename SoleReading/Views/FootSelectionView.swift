import SwiftUI
import PhotosUI

struct FootSelectionView: View {
    @State private var selectedFoot: FootSide = .right
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var navigateToAnalysis = false
    @State private var imagePickerItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.14, blue: 0.11).ignoresSafeArea()

            VStack(spacing: 0) {
                // Foot selector
                VStack(spacing: 14) {
                    Text("どちらの足を診断しますか？")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(red: 0.88, green: 0.76, blue: 0.38))
                    Text("Which foot would you like to scan?")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(red: 0.45, green: 0.58, blue: 0.47))

                    HStack(spacing: 14) {
                        ForEach(FootSide.allCases, id: \.self) { side in
                            FootSideButton(side: side, isSelected: selectedFoot == side) {
                                selectedFoot = side
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                Divider()
                    .overlay(Color(red: 0.22, green: 0.32, blue: 0.24))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)

                // Tips
                VStack(spacing: 12) {
                    HStack {
                        Text("撮影のコツ  /  Photo Tips")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(red: 0.50, green: 0.68, blue: 0.53))
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        TipRow(icon: "arrow.up", text: "つま先を上にして撮影してください")
                        TipRow(icon: "crop", text: "足裏全体がフレームに収まるように")
                        TipRow(icon: "sun.max", text: "明るい場所で撮影すると精度が上がります")
                    }
                    .padding(16)
                    .background(Color(red: 0.12, green: 0.18, blue: 0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)

                Spacer()

                // Photo buttons
                VStack(spacing: 12) {
                    Button { showCamera = true } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                            Text("カメラで撮影")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.90, green: 0.78, blue: 0.40), Color(red: 0.76, green: 0.58, blue: 0.24)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    PhotosPicker(selection: $imagePickerItem, matching: .images) {
                        HStack(spacing: 10) {
                            Image(systemName: "photo.on.rectangle")
                            Text("フォトライブラリから選択")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(Color(red: 0.78, green: 0.84, blue: 0.78))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.14, green: 0.20, blue: 0.16))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(red: 0.28, green: 0.42, blue: 0.30), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
            }
        }
        .navigationTitle("足の選択")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showCamera) {
            CameraPickerView(image: $selectedImage)
        }
        .onChange(of: imagePickerItem) { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    selectedImage = img
                }
            }
        }
        .onChange(of: selectedImage) { img in
            if img != nil { navigateToAnalysis = true }
        }
        .navigationDestination(isPresented: $navigateToAnalysis) {
            if let image = selectedImage {
                AnalysisView(image: image, footSide: selectedFoot)
            }
        }
    }
}

struct FootSideButton: View {
    let side: FootSide
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("🦶")
                    .font(.system(size: 34))
                    .scaleEffect(x: side == .left ? -1 : 1)
                Text(side.rawValue)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.black : Color(red: 0.78, green: 0.84, blue: 0.78))
                Text(side.englishName)
                    .font(.system(size: 11))
                    .foregroundStyle(isSelected ? Color.black.opacity(0.6) : Color(red: 0.45, green: 0.58, blue: 0.47))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isSelected
                ? LinearGradient(colors: [Color(red: 0.90, green: 0.78, blue: 0.40), Color(red: 0.76, green: 0.58, blue: 0.24)], startPoint: .top, endPoint: .bottom)
                : LinearGradient(colors: [Color(red: 0.14, green: 0.22, blue: 0.17), Color(red: 0.12, green: 0.18, blue: 0.14)], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.clear : Color(red: 0.28, green: 0.42, blue: 0.30).opacity(0.5), lineWidth: 1))
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(Color(red: 0.50, green: 0.68, blue: 0.53))
                .frame(width: 20)
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(Color(red: 0.70, green: 0.78, blue: 0.70))
        }
    }
}

struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        init(_ parent: CameraPickerView) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let img = info[.originalImage] as? UIImage { parent.image = img }
            parent.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
