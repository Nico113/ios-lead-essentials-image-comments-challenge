//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentPresenter {
	public static func map(_ image: ImageComment) -> ImageCommentViewModel {
		ImageCommentViewModel(
			author: image.author,
			date: formatter.localizedString(for: image.createdAt, relativeTo: Date()),
			comment: image.message)
	}

	static var formatter = RelativeDateTimeFormatter()
}
