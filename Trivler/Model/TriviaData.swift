//
//  TriviaData.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/1/21.
//

import Foundation

struct TriviaData: Codable {
    
    let response_code: Int
    let results: [Results]
    
}

struct Results: Codable {
    
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
}
