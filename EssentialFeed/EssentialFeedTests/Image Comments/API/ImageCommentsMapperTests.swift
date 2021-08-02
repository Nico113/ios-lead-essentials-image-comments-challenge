//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
@testable import EssentialFeed

struct ImageComment: Hashable {
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

class ImageCommentsMapper {
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

	public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		guard response.isRangeOK, let root = try? decoder.decode(Root.self, from: data) else {
			throw Error.invalidData
		}

		return root.comments
	}
}

extension HTTPURLResponse {
	private static var OK_2xx: Range<Int> { return 200 ..< 300 }

	var isRangeOK: Bool {
		return HTTPURLResponse.OK_2xx.contains(statusCode)
	}
}

class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [199, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)
		let samples = [200, 201, 202, 203]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])
		let samples = [200, 201, 202, 203]

		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [])
		}
	}

	func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
		let item1 = makeItem(
			id: UUID(),
			message: "a message",
			creationDate: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
			author: "a username")

		let item2 = makeItem(
			id: UUID(),
			message: "another message",
			creationDate: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
			author: "another username")

		let json = makeItemsJSON([item1.json, item2.json])
		let samples = [200, 201, 202, 203]

		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [item1.model, item2.model])
		}
	}

	// MARK: - Helpers

	private func makeItem(id: UUID, message: String, creationDate: (date: Date, iso8601String: String), author: String) -> (model: ImageComment, json: [String: Any]) {
		let item = ImageComment(id: id, message: message, createdAt: creationDate.date, author: author)

		let json = [
			"id": id.uuidString,
			"message": message,
			"created_at": creationDate.iso8601String,
			"author": ["username": author]
		].compactMapValues { $0 }

		return (item, json)
	}
}
