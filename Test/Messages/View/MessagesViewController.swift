import UIKit

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let presenter = MessagesPresenter(service: .init())
    private var scrollToIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        presenter.setViewDelegate(delegate: self)
        configureItems()
        configureCollectionView()
        presenter.loadFirstMessages()
    }
    
    private func configureItems() {
        title = "Messages"
        let button = UIBarButtonItem(
            image: UIImage(systemName: "list.number"),
            menu: makeMenu()
        )
        navigationItem.rightBarButtonItem =  button
    }
    
    private func getRowSize(message: String) -> CGSize {
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let horozontalOffset: CGFloat = 32
        let titleLabelHeight: CGFloat = 21
        let titleLabelVerticalOffset: CGFloat = 16
        let messageLabelVerticalOffset: CGFloat = 16
        let width: CGFloat = collectionView.bounds.width - horozontalOffset
        let height = message.height(width: width, font: font) + titleLabelHeight + titleLabelVerticalOffset + messageLabelVerticalOffset
        return CGSize(width: width, height: height)
    }
    
    func makeMenu() -> UIMenu {
        let jumpAction = UIAction(
            title: "Jump to 1000"
        ) { _ in
            /// User can jump to any "messageNumber" of message
            // let messageNumber = self.getRandomNumber()
            // print("messageNumber: \(messageNumber)")
            // self.presenter.jumpToMessage(messageNumber: messageNumber)
            self.presenter.jumpToMessage(messageNumber: 1000)
        }
        return UIMenu(
            title: "Jump to",
            options: [.displayInline],
            children: [jumpAction]
        )
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: "MessageCell", bundle: nil),
            forCellWithReuseIdentifier: "MessageCell"
        )
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = layout
    }
    
    private func setCollectionViewContentOffset() {
        if let currentSectionFrame = collectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame {
            let currentSectionOffset = currentSectionFrame.origin.y
            collectionView.setContentOffset(CGPoint(x: 0, y: currentSectionOffset), animated: false)
        }
    }
    
    private func getRandomNumber() -> Int {
        return Int.random(in: 0..<1000000)
    }
}

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.pages[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let item = presenter.pages[indexPath.section].items[indexPath.row]
        let pageNumber = presenter.pages[indexPath.section].pageNumber
        let messageNumber = (pageNumber * presenter.pageSize) + indexPath.item
        cell.fill(message: item.text, messageNumber: messageNumber)
        
        if let scrollToIndexPath = scrollToIndexPath, indexPath == scrollToIndexPath {
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1.0
                self.scrollToIndexPath = nil
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = presenter.pages[indexPath.section].items[indexPath.row]
        return getRowSize(message: item.text)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && !presenter.isLoading && presenter.currentPage != 0 {
            presenter.loadPreviousMessages()
        } else if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && !presenter.isLoading {
            presenter.loadNextMessages()
        }
    }
}

extension MessagesViewController: MessagesViewDelegate {
    
    func reloadMessageList() {
        collectionView.reloadData()
    }
    
    func updateMessageList() {
        collectionView.reloadData()
        setCollectionViewContentOffset()
    }
    
    func updateMessageListAfterJump() {
        collectionView.reloadData()
        let item = presenter.messageNumber % presenter.pageSize
        let indexPath = IndexPath(item: item, section: 1)
        scrollToIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}
