//
//  TriviaProvider.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 5/28/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import GameKit


class GameManager    {
    let trivia: [[String: String]] = [
        ["Question": "This was the only US President to serve more than two consecutive terms:",
         "Choice 1": "George Washington",
         "Choice 2": "Franklin D. Roosevelt",
         "Choice 3": "Woodrow Wilson",
         "Choice 4": "Andrew Jackson",
         "Answer": "Franklin D. Roosevelt"],
        ["Question": "Which of the following countries has the most residents?",
         "Choice 1": "Nigeria",
         "Choice 2": "Russia",
         "Choice 3": "Iran",
         "Choice 4": "Vietnam",
         "Answer": "Nigeria"],
        ["Question": "In what year was the United Nations founded?",
         "Choice 1": "1918",
         "Choice 2": "1919",
         "Choice 3": "1945",
         "Choice 4": "1954",
         "Answer": "1945"],
        ["Question": "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
         "Choice 1": "Paris",
         "Choice 2": "Washington D.C.",
         "Choice 3": "New York City",
         "Choice 4": "Boston",
         "Answer": "New York City"],
        ["Question": "Which nation produces the most oil?",
         "Choice 1": "Iran",
         "Choice 2": "Iraq",
         "Choice 3": "Brazil",
         "Choice 4": "Canada",
         "Answer": "Canada"],
        ["Question": "Which country has most recently won consecutive World Cups in Soccer?",
         "Choice 1": "Italy",
         "Choice 2": "Brazil",
         "Choice 3": "Argentina",
         "Choice 4": "Spain",
         "Answer": "Brazil"],
        ["Question": "Which of the following rivers is longest?",
         "Choice 1": "Yangtze",
         "Choice 2": "Mississippi",
         "Choice 3": "Congo",
         "Choice 4": "Mekong",
         "Answer": "Mississippi"],
        ["Question": "Which city is the oldest?",
         "Choice 1": "Mexico City",
         "Choice 2": "Cape Town",
         "Choice 3": "San Juan",
         "Choice 4": "Sydney",
         "Answer": "Mexico City"],
        ["Question": "Which country was the first to allow women to vote in national elections?",
         "Choice 1": "Poland",
         "Choice 2": "United States",
         "Choice 3": "Sweden",
         "Choice 4": "Senegal",
         "Answer": "Poland"],
        ["Question": "Which of these countries won the most medals in the 2012 Summer Games?",
         "Choice 1": "France",
         "Choice 2": "Germany",
         "Choice 3": "Japan",
         "Choice 4": "Great Britian",
         "Answer": "Great Britian"],
    ]
    
    let questionsPerRound: Int
    var questionsAsked: Int = 0
    var correctQuestions: Int = 0
    var indexOfSelectedQuestion: Int = 0
    var questionsUsed: [Int] = []
    let quiz: QuizModel
    var questions: [QuestionModel] = []
    
    init(questionsPerRound: Int) {
        self.questionsPerRound = questionsPerRound
        let numberOfQuestions = self.questionsPerRound * 2
        let randomTrivia = trivia.shuffled()
        
        //Create randomized question set for quiz and setup quiz object
        for index in 0..<numberOfQuestions  {
            let question: String = randomTrivia[index]["Question"]!
            let answer: String = randomTrivia[index]["Answer"]!
            var choices: [String] = []
            for (key, value) in randomTrivia[index] {
                if key.hasPrefix("Choice")  {
                    choices.append(value)
                }
            }
            self.questions.append(QuestionModel(question: question, choices: choices, answer: answer))
        }
        self.quiz = QuizModel(questions: self.questions)
    }
    
    func randomQuestion() -> QuestionModel {
        repeat  {
            self.indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: self.quiz.questions.count)
        } while questionsUsed.contains(indexOfSelectedQuestion) == true
        
        let question: QuestionModel = self.quiz.questions[indexOfSelectedQuestion]
        self.questionsUsed.append(indexOfSelectedQuestion)
        
        return question
    }
    func scorePercentage() -> Double {
        return Double(self.correctQuestions)/Double(self.questionsAsked)
    }
}
