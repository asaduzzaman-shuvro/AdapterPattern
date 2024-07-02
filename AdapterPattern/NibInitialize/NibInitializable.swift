//
//  NibInitializable.swift
//  AdapterPattern
//
//  Created by Asaduzzaman Shuvro on 2/7/24.
//

import UIKit

protocol NibInitializable {
    static var nibName: String { get }
}

extension NibInitializable {
    static var nibName: String {
        String(describing: self)
    }
}

extension UIViewController: NibInitializable {
    static func fromNib() -> Self {
        let bundle = Bundle(for: Self.self)
        return Self(nibName: nibName, bundle: bundle)
    }
}
