//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
	private static var OK_200: Int { return 200 }

	var isOK: Bool {
		return statusCode == HTTPURLResponse.OK_200
	}
}

extension HTTPURLResponse {
	private static var OK_2xx: Range<Int> { return 200 ..< 300 }

	var isRangeOK: Bool {
		return HTTPURLResponse.OK_2xx.contains(statusCode)
	}
}
