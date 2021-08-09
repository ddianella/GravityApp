//
//  ViewModel.swift
//  GravityTestApp
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var isLoaderVisible = PassthroughSubject<Bool, Never>();
    var webTitle = PassthroughSubject<String, Never>()
    var webViewNavigationPublisher = PassthroughSubject<WebViewNavigationAction, Never>()
}
