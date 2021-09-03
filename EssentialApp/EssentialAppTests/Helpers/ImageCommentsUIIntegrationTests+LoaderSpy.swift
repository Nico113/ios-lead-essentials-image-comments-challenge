//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import EssentialFeediOS
import Combine

extension ImageCommentsUIIntegrationTests {
	class LoaderSpy {
		private var imageCommentRequests = [PassthroughSubject<[ImageComment], Error>]()

		var loadImageCommentsCallCount: Int {
			return imageCommentRequests.count
		}

		func loadPublisher() -> AnyPublisher<[ImageComment], Error> {
			let publisher = PassthroughSubject<[ImageComment], Error>()
			imageCommentRequests.append(publisher)
			return publisher.eraseToAnyPublisher()
		}

		func completeImageCommentsLoading(with feed: [ImageComment] = [], at index: Int = 0) {
			imageCommentRequests[index].send(feed)
		}

		func completeImageCommentsLoadingWithError(at index: Int = 0) {
			let error = NSError(domain: "an error", code: 0)
			imageCommentRequests[index].send(completion: .failure(error))
		}
	}
}
