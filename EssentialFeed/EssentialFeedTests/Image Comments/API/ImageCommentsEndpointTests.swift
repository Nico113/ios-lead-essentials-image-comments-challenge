//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
	func test_imageComments_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let received = ImageCommentEndpoint.get.url(baseURL: baseURL, imageId: "imageId")
		let expected = URL(string: "http://base-url.com/v1/image/imageId/comments")!

		XCTAssertEqual(received, expected)
	}
}
