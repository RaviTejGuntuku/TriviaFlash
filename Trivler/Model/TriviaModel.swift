//
//  TriviaModel.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/1/21.
//

import Foundation

struct TriviaModel {
    
    let questions: [Question]
    
}

struct Question {
    
    let question: String
    
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    var options: [String] = []
    
    init(q: String, correctAns: String, incorrectAns: [String]) {
        
        question = q
        
        correctAnswer = correctAns
        incorrectAnswers = incorrectAns
        
        options.append(correctAnswer)
        
        for answer in incorrectAnswers {
            options.append(answer)
        }
        
        options = options.shuffled()
    }
    
}
