//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
@testable import EssentialFeed

struct LocalImageComment: Equatable {
	public let id: UUID
	public let message: String
	public let createdAt: Date
	public let author: String

	public init(id: UUID, message: String, createdAt: Date, author: String) {
		self.id = id
		self.message = message
		self.createdAt = createdAt
		self.author = author
	}
}

struct ImageCommentsViewModel {
	public let imageComments: [ImageComment]
}

class ImageCommentsPresenter {
	public static var title: String {
		NSLocalizedString(
			"IMAGE_COMMENTS_VIEW_TITLE",
			tableName: "ImageComments",
			bundle: Bundle(for: FeedPresenter.self),
			comment: "Title for the image comments view")
	}

	public static func map(_ imageComments: [ImageComment]) -> ImageCommentsViewModel {
		ImageCommentsViewModel(imageComments: imageComments)
	}
}

class ImageCommentsPresenterTests: XCTestCase {
	func test_title_isLocalized() {
		XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
	}

	func test_map_createsViewModel() {
		let comments = uniqueImageComments().models

		let viewModel = ImageCommentsPresenter.map(comments)

		XCTAssertEqual(viewModel.imageComments, comments)
	}

	// MARK: - Helpers

	private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "ImageComments"
		let bundle = Bundle(for: FeedPresenter.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}

	private func uniqueImageComment() -> ImageComment {
		return ImageComment(id: UUID(), message: "a message", createdAt: Date(), author: "an author")
	}

	private func uniqueImageComments() -> (models: [ImageComment], local: [LocalImageComment]) {
		let models = [uniqueImageComment(), uniqueImageComment()]
		let local = models.map { LocalImageComment(id: $0.id, message: $0.message, createdAt: $0.createdAt, author: $0.author) }
		return (models, local)
	}
}
