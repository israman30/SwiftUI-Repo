//
//  MainView.swift
//  PDF Loader
//
//  Created by Israel Manzo on 8/4/24.
//

import SwiftUI
import PDFKit

enum PDFImport {
    case loading
    case error(PDFError)
    case loaded(PDFDocument)
    case empty
}

final class PDFImportViewModel: ObservableObject {
    @Published var pdfImport: PDFImport = .empty
    @Published var isPresentingPdfImport: Bool = true
    
    /// Shows pdf importer
    public func showPdfImporter() {
        isPresentingPdfImport = true
    }
    
    public func pdfWasSelected(result: Result<URL, Error>) {
        pdfImport = .loading
        /// Load pdf in background
        switch result {
        case .success(let url):
            Task {
                /// Check Security
                guard
                    url.startAccessingSecurityScopedResource(),
                    let pdfDocument = PDFDocument(url: url)
                else {
                    /// startAccessingSecurityScopedResource returns false e.g. when trying to upload virus
                    url.stopAccessingSecurityScopedResource()
                    Task.detached { @MainActor in
                        self.pdfImport = .error(PDFImportError())
                    }
                    return
                }
                
                Task.detached { @MainActor in
                    self.pdfImport = .loaded(pdfDocument)
                }
                url.stopAccessingSecurityScopedResource()
            }
        case .failure:
            /// Error from apple fileimporter (corrupt files for e.g.)
            pdfImport = .error(PDFImportError())
        }
    }
}

struct MainView: View {
    
    @StateObject var vm = PDFImportViewModel()
    
    var body: some View {
        ZStack {
            switch vm.pdfImport {
            case .loading:
                PdfImporterLoadingView()
            case .error(let error):
                PdfImporterErrorView(pdfError: error, backToFileImportAction: vm.showPdfImporter)
            case .loaded(let selectedPdf):
                PdfImporterLoadedView(selectedPdf: selectedPdf, backToFileImportAction: vm.showPdfImporter)
            case .empty:
                EmptyPdfImporterView(backToFileImportAction: vm.showPdfImporter)
            }
        }.fileImporter(
            isPresented: $vm.isPresentingPdfImport,
            allowedContentTypes: [.pdf]
        ) { result in
            vm.pdfWasSelected(result: result)
        }
    }
}

#Preview {
    MainView()
}

struct PdfImporterLoadingView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            ProgressView()
                .frame(width: 56, height: 56)
                .padding(.vertical, 16)
                .padding(.bottom, 8)
            Text("Loading PDF")
            Spacer()
            PdfImporterBottomSheet()
        }
        .frame(maxWidth: .infinity)
    }
}

struct PdfImporterBottomSheet: View {
    var backToFileImportAction: (() -> Void)?
    var body: some View {
        VStack(spacing: 0) {
            Button {
                backToFileImportAction
            } label: {
                Text("Import another pdf")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(.white)
        .background(
            Color.white
                .shadow(
                    color: Color.black.opacity(16),
                    radius: 8
                )
        )
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdf: PDFDocument
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        DispatchQueue.main.async {
            uiView.document = pdf
        }
    }
}


struct PdfImporterLoadedView: View {
    let selectedPdf: PDFDocument
    let backToFileImportAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            PDFKitView(pdf: selectedPdf)
            PdfImporterBottomSheet(
                backToFileImportAction: backToFileImportAction
            )
        }
    }
}

struct EmptyPdfImporterView: View {
    let backToFileImportAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: "person")
                .resizable()
                .frame(
                    width: 20,
                    height: 20
                )
                .scaledToFit()
                .padding(.bottom, 40)
            Text("Empty PDF title")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            Text("empty pdf description")
                .multilineTextAlignment(.center)
            Spacer()
            Button("Back") {
                //           backToFileImportAction
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 20)
        .preferredColorScheme(.light)
    }
}

protocol PDFError {
    var prexif: String { get }
    var illustrationName: String { get }
    var title: String { get }
    var description: String { get }
    var buttonTitle: String { get }
}

struct PDFImportError: PDFError, Error {
    var prexif: String = "PDFImportError"
    var illustrationName: String = "ImageNames.error"
    var title: String = "Texts.importErrorTitle"
    var description: String = "Texts.importErrorDescription"
    var buttonTitle: String = "Texts.importAnotherPdf"
}

struct PdfImporterErrorView: View {
    let pdfError: PDFError
    let backToFileImportAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(pdfError.illustrationName)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.bottom, 40)
            Text(pdfError.title)
                .font(.title)
                .padding(.bottom, 16)
            Text(pdfError.description)
                .multilineTextAlignment(.center)
            Spacer()
            Button(
                pdfError.buttonTitle,
                action: backToFileImportAction
            )
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 20)
        .background(.white)
    }
}
