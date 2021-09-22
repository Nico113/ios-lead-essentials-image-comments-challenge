//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsMapper {
	private struct Root: Decodable {
		private let items: [RemoteImageComment]

		private struct Author: Decodable {
			let username: String
		}

		private struct RemoteImageComment: Decodable {
			let id: UUID
			let message: String
			let created_at: Date
			let author: Author
		}

		var comments: [ImageComment] {
			items.map { ImageComment(id: $0.id, message: $0.message, createdAt: $0.created_at, author: $0.author.username) }
		}
	}

	public enum Error: Swift.Error {
		case invalidData
	}

	private init() {}

	public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		guard response.isStatusCodeOK, let root = try? decoder.decode(Root.self, from: data) else {
			throw Error.invalidData
		}

		return root.comments
	}
}

extension HTTPURLResponse {
	private static var OK_2xx: Range<Int> { return 200 ..< 300 }

	var isStatusCodeOK: Bool {
		return HTTPURLResponse.OK_2xx.contains(statusCode)
	}
}
