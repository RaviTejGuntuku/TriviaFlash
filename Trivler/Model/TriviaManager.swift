//
//  QuestionsManager.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/1/21.
//

import Foundation

protocol TriviaManagerDelegate {
    func didGetQuestions(_ triviaManager: TriviaManager, triviaModel: TriviaModel)
    func didFailWithError(_ error: Error)
}


struct TriviaManager {
    
    let triviaDatabaseURL = "https://opentdb.com/api.php?type=multiple&encode=url3986"
    
    var delegate: TriviaManagerDelegate?
    
    func fetchQuestions () {
        
        var categoryID: Int {
            switch categoryName {
            case "Random":
                return 0
            case "Computers":
                return 18
            case "Art":
                return 25
            case "History":
                return 23
            case "Math":
                return 19
            case "Science":
                return 17
            case "Sports":
                return 21
            case "Entertainment":
                return 11
            default:
                return 0
            }
        }
        
        let urlString = "\(triviaDatabaseURL)&amount=\(numberOfQuestions)&category=\(categoryID)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    print("Error: \(error!)")
                    return
                }
                
                if let safeData = data {
                    if let trivia = self.parseJSON(safeData) {
                        self.delegate?.didGetQuestions(self, triviaModel: trivia)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ triviaQuestions: Data) -> TriviaModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(TriviaData.self, from: triviaQuestions)
            let questions = decodedData.results
            
            var questionsArray: [Question] = []
            
            for question in questions {
                
                let decodedQuestion = question.question.removingPercentEncoding!
                let decodedAnswer = question.correct_answer.removingPercentEncoding!
                
                let incorrectAnswers = question.incorrect_answers
                var decodedIncorrectAnswers: [String] = []
                
                for answer in incorrectAnswers {
                    
                    let decodedIncorrectAnswer = answer.removingPercentEncoding
                    decodedIncorrectAnswers.append(decodedIncorrectAnswer!)
                    
                }
                
                let questionStruct = Question(q: decodedQuestion, correctAns: decodedAnswer, incorrectAns: decodedIncorrectAnswers)
                
                questionsArray.append(questionStruct)
            }
            
            let triviaModel = TriviaModel(questions: questionsArray)
            return triviaModel
            
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    
    
    
}
