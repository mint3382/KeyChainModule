//
//  KeyChainError.swift
//  KeyChainModule
//
//  Created by minsong kim on 4/3/25.
//

import Foundation

public enum KeyChainError: Error {
    case dataEncodingFailed
    case keyChainOperationFailed(OSStatus)
}
