//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
@testable import EssentialFeed

class ImageCommentPresenterTests: XCTestCase {
	func test_map_createsViewModel() {
		let imageComment = uniqueImageComment()

		let viewModel = ImageCommentPresenter.map(imageComment)

		let formatter = RelativeDateTimeFormatter()

		XCTAssertEqual(viewModel.author, imageComment.author)
		XCTAssertEqual(viewModel.date, formatter.localizedString(for: imageComment.createdAt, relativeTo: Date()))
		XCTAssertEqual(viewModel.comment, imageComment.message)
	}

	// MARK: - Helpers
	private func uniqueImageComment() -> ImageComment {
		return ImageComment(id: UUID(), message: "a message", createdAt: Date(), author: "an author")
	}
}
