//
//  ImageSelectionQuestion.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 05/09/2017.
//  Copyright © 2017 3sidedcube. All rights reserved.
//

import UIKit

/// An image selection option for an ImageSelectionQuestion
struct ImageOption {
	
	let title: String?
	
	let image: UIImage?
}


/// The user is presented with a selection of images to choose from
class ImageSelectionQuestion: QuizQuestion {
	
	let options: [ImageOption]
	
	let correctAnswer: [Int]
	
	let limit: Int
	
	var answer: [Int] = [] {
		didSet {
			postNotification(notification: .answerChanged, object: self)
		}
	}
	
	override init?(dictionary: [AnyHashable : Any]) {
		
		guard let imageDictionaries = dictionary["images"] as? [Any] else { return nil }
		guard let options = dictionary["options"] as? [[AnyHashable : Any]] else { return nil }
		
		guard options.count == imageDictionaries.count, options.count > 0 else { return nil }
		
		
		self.options = options.enumerated().map({ (index, option) -> ImageOption in
			
			let image: UIImage? = StormGenerator.image(fromJSON: imageDictionaries[index])
			return ImageOption(title: StormLanguageController.shared.string(for: option), image: image)
		})
		
		if let limit = dictionary["limit"] as? Int {
			self.limit = limit
		} else {
			limit = 0
		}
		
		guard let answer = dictionary["answer"] as? [Int] else { return nil }
		correctAnswer = answer
		
		super.init(dictionary: dictionary)
	}
	
	override var isCorrect: Bool {
		get {
			return correctAnswer.sorted(by: {$0>$1}) == answer.sorted(by: {$0>$1})
		}
		set {}
	}
	
	override var answered: Bool {
		get {
			return limit > 0 ? (answer.count == limit) : (answer.count > 0)
		}
		set {}
	}
	
	override func reset() {
		answer = []
	}
	
	override func answerCorrectly() {
		answer = correctAnswer
	}
	
	override func answerRandomly() {
		while answer.count < limit {
			let answerOption = Int(arc4random_uniform(UInt32(options.count)))
			if !answer.contains(answerOption) {
				answer.append(answerOption)
			}
		}
	}
}