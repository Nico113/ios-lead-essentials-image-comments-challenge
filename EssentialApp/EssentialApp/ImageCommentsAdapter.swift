//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsAdapter: ResourceView {
	private weak var controller: ListViewController?

	init(controller: ListViewController) {
		self.controller = controller
	}

	func display(_ viewModel: ImageCommentsViewModel) {
		controller?.display(viewModel.imageComments.map { imageComment in
			return CellController(
				id: imageComment,
				ImageCommentCellController(
					viewModel: ImageCommentPresenter.map(imageComment)))
		})
	}
}
