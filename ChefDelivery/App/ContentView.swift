//
//  ContentView.swift
//  ChefDelivery
//
//  Created by ALURA on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    
    //-----------------------------------------------------------------------
    // MARK: - Attributes
    //-----------------------------------------------------------------------
    
    private let homeService = HomeService()
    
    @State private var storesType: [StoreType] = []
    
    @State private var isLoading = true //variavel responsável por controlar o loading da tela
    
    //-----------------------------------------------------------------------
    // MARK: - View
    //-----------------------------------------------------------------------

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    NavigationBar()
                        .padding(.horizontal, 15)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            OrderTypeGridView()
                            CarouselTabView()
                            StoresContainerView(stores: storesType)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await getStores()
            }
            //getStoreWithAlamofire() 
        }
    }
    
    //-----------------------------------------------------------------------
    // MARK: - methods
    //-----------------------------------------------------------------------
    
    func getStores() async {
        do {
            let result = try await homeService.fetchData()
            switch result {
            case .success(let stores):
                self.storesType = stores
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
            self.isLoading = false
        }
    }
    
    func getStoreWithAlamofire() {
        homeService.fecthDataWithAlamofire { stores, error in
            print(stores)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
