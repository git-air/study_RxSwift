//
//  String+URL.swift
//  LearnRxSwift3
//
//  Created by AIR on 2022/08/02.
//

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
