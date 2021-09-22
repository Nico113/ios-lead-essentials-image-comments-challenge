//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public enum ImageCommentEndpoint {
	case get(UUID)

	public func url(baseURL: URL) -> URL {
		switch self {
		case .get(let imageId):
			return baseURL.appendingPathComponent("/v1/image/\(imageId.uuidString)/comments")
		}
	}
}
