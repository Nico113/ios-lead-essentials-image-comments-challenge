//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
	private init() {}

	private typealias ImageCommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], ImageCommentsAdapter>

	public static func imageCommentsComposedWith(
		imageCommentLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
	) -> ListViewController {
		let presentationAdapter = ImageCommentsPresentationAdapter(loader: imageCommentLoader)

		let imageCommentsController = makeImageCommentViewController(title: ImageCommentsPresenter.title)
		imageCommentsController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: ImageCommentsAdapter(
				controller: imageCommentsController),
			loadingView: WeakRefVirtualProxy(imageCommentsController),
			errorView: WeakRefVirtualProxy(imageCommentsController),
			mapper: ImageCommentsPresenter.map)

		return imageCommentsController
	}

	private static func makeImageCommentViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let imageCommentsController = storyboard.instantiateInitialViewController() as! ListViewController
		imageCommentsController.title = title
		return imageCommentsController
	}
}
