//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension ImageCommentsUIIntegrationTests {
	var dateFormatter: RelativeDateTimeFormatter {
		return RelativeDateTimeFormatter()
	}

	func assertThat(_ sut: ListViewController, isRendering imageComments: [ImageComment], file: StaticString = #filePath, line: UInt = #line) {
		sut.view.enforceLayoutCycle()

		guard sut.numberOfRenderedFeedImageViews() == imageComments.count else {
			return XCTFail("Expected \(imageComments.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
		}

		imageComments.enumerated().forEach { index, imageComment in
			assertThat(sut, hasViewConfiguredFor: imageComment, at: index, file: file, line: line)
		}

		executeRunLoopToCleanUpReferences()
	}

	func assertThat(_ sut: ListViewController, hasViewConfiguredFor imageComment: ImageComment, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
		let view = sut.feedImageView(at: index)

		guard let cell = view as? ImageCommentCell else {
			return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.commentLabel.text, imageComment.message, "Expected message text to be \(String(describing: imageComment.message)) for image comment view at index (\(index))", file: file, line: line)

		XCTAssertEqual(cell.authorLabel.text, imageComment.author, "Expected author text to be \(String(describing: imageComment.author)) for image comment view at index (\(index)", file: file, line: line)

		let createdAt = dateFormatter.localizedString(for: imageComment.createdAt, relativeTo: Date())
		XCTAssertEqual(cell.dateLabel.text, createdAt, "Expected creation date text to be \(String(describing: createdAt)) for image comment view at index (\(index)", file: file, line: line)
	}

	private func executeRunLoopToCleanUpReferences() {
		RunLoop.current.run(until: Date())
	}
}
