//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentEndpointTests: XCTestCase {
	func test_imageComments_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let uuid = UUID()
		let received = ImageCommentEndpoint.get(uuid).url(baseURL: baseURL)
		let expected = URL(string: "http://base-url.com/v1/image/\(uuid.uuidString)/comments")!

		XCTAssertEqual(received, expected)
	}
}
