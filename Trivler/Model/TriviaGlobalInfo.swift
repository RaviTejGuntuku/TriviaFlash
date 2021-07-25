//
//  QuizInfo.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/27/21.
//

import UIKit


class TriviaInfo {
    
    static let shared = TriviaInfo()
    
    var categoryName: String?
    var categoryColor: UIColor?
    
    var numberOfQuestions: Int = 5
    var timeForQuestion: Int = 30

    let categoriesColors: [String: UIColor] = [
        "Random": UIColor(red: 176/255, green: 193/255, blue: 201/255, alpha: 1),
        "Computers": UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1),
        "Art": UIColor(red: 255/255, green: 22/255, blue: 22/255, alpha: 1),
        "History": UIColor(red: 178/255, green: 153/255, blue: 119/255, alpha: 1),
        "Math": UIColor(red: 155/255, green: 205/255, blue: 222/255, alpha: 1),
        "Science": UIColor(red: 0/255, green: 128/255, blue: 55/255, alpha: 1),
        "Sports": UIColor(red: 254/255, green: 145/255, blue: 77/255, alpha: 1),
        "Movies": UIColor(red: 140/255, green: 82/255, blue: 255/255, alpha: 1)
    ]

    func resetVariables() {
        self.categoryName = nil
        self.categoryColor = nil
        
        self.numberOfQuestions = 5
        self.timeForQuestion = 30
    }

}
