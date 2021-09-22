//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension ImageCommentsUIIntegrationTests {
	func assertThat(_ sut: ListViewController, isRendering imageComments: [ImageComment], file: StaticString = #filePath, line: UInt = #line) {
		sut.view.enforceLayoutCycle()

		guard sut.numberOfRenderedFeedImageViews() == imageComments.count else {
			return XCTFail("Expected \(imageComments.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
		}

		imageComments.enumerated().forEach { index, imageComment in
			assertThat(sut, hasViewConfiguredFor: imageComment, at: index, file: file, line: line)
		}
	}

	func assertThat(_ sut: ListViewController, hasViewConfiguredFor imageComment: ImageComment, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
		let viewModel = ImageCommentPresenter.map(imageComment)

		XCTAssertEqual(sut.commentText(at: index), viewModel.comment, "message at index \(index) ", file: file, line: line)
		XCTAssertEqual(sut.authorText(at: index), viewModel.author, "author at index \(index) ", file: file, line: line)
		XCTAssertEqual(sut.dateText(at: index), viewModel.date, "creation date at index \(index) ", file: file, line: line)
	}
}

extension ListViewController {
	private func getImageCommentCell(at index: Int, file: StaticString = #filePath, line: UInt = #line) -> ImageCommentCell? {
		let view = feedImageView(at: index)

		guard let cell = view as? ImageCommentCell else {
			XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
			return nil
		}

		return cell
	}

	func commentText(at index: Int, file: StaticString = #filePath, line: UInt = #line) -> String? {
		return getImageCommentCell(at: index)?.commentLabel.text
	}

	func authorText(at index: Int, file: StaticString = #filePath, line: UInt = #line) -> String? {
		return getImageCommentCell(at: index)?.authorLabel.text
	}

	func dateText(at index: Int, file: StaticString = #filePath, line: UInt = #line) -> String? {
		return getImageCommentCell(at: index)?.dateLabel.text
	}
}
