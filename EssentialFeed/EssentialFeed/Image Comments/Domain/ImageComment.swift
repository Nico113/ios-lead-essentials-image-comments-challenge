//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageComment: Hashable {
	public let id: UUID
	public let message: String
	public let createdAt: Date
	public let author: String
}
