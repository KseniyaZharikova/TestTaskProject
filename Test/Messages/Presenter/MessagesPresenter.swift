import Foundation

protocol MessagesViewDelegate: NSObjectProtocol {
    func updateMessageListAfterJump()
    func updateMessageList()
    func reloadMessageList()
}

class MessagesPresenter {
    
    private let service: MessagesService
    weak private var viewDelegate : MessagesViewDelegate?
    
    var pages: [Page] = []
    let pageSize = 20
    var currentPage = 0
    var previousPage = 0
    var nextPage = 0
    var currentSection = 1
    var isLoading = false
    var messageNumber = 0
    
    init(service: MessagesService){
        self.service = service
    }
    
    func setViewDelegate(delegate: MessagesViewDelegate?) {
        self.viewDelegate = delegate
    }
    
    func jumpToMessage(messageNumber: Int) {
        guard !isLoading else {
            return
        }
        
        self.messageNumber = messageNumber
        isLoading = true
        let pageNumber = messageNumber / pageSize
        previousPage = pageNumber - 1
        currentPage = pageNumber
        nextPage = pageNumber + 1
        
        let previousPageData = service.getMockMessages()
        let pageData = service.getMockMessages()
        let nextPageData = service.getMockMessages()
        
        let previous = Page(pageNumber: previousPage, items: previousPageData)
        let page = Page(pageNumber: currentPage, items: pageData)
        let next = Page(pageNumber: nextPage, items: nextPageData)
        
        pages.removeAll()
        pages.append(contentsOf: [previous, page, next])
        
        viewDelegate?.updateMessageListAfterJump()
        self.isLoading = false
    }
    
    func loadPreviousMessages() {
        guard !isLoading else {
            return
        }
        
        currentPage -= 1
        isLoading = true
        previousPage = currentPage - 1
        
        let previousPageData = service.getMockMessages()
        let pageData = service.getMockMessages()
        
        let previous = Page(pageNumber: previousPage, items: previousPageData)
        let page = Page(pageNumber: currentPage, items: pageData)
        
        pages.removeAll { $0.pageNumber == currentPage }
        pages.insert(contentsOf: [page, previous], at: 0)
        viewDelegate?.updateMessageList()
        self.isLoading = false
    }
    
    func loadNextMessages() {
        guard !isLoading else {
            return
        }
        currentPage += 1
        isLoading = true
        nextPage = currentPage + 1
        
        let pageData = service.getMockMessages()
        let nextPageData = service.getMockMessages()
        let page = Page(pageNumber: currentPage, items: pageData)
        let next = Page(pageNumber: nextPage, items: nextPageData)
        
        pages.removeAll { $0.pageNumber == currentPage }
        pages.append(contentsOf: [page, next])
        viewDelegate?.reloadMessageList()
        self.isLoading = false
    }
    
    func loadFirstMessages() {
        guard !isLoading else {
            return
        }
        isLoading = true
        nextPage = currentPage + 1
        
        let pageData = service.getMockMessages()
        let nextPageData = service.getMockMessages()
        let page = Page(pageNumber: currentPage, items: pageData)
        let next = Page(pageNumber: nextPage, items: nextPageData)
        
        pages.removeAll { $0.pageNumber == currentPage }
        pages.append(contentsOf: [page, next])
        viewDelegate?.reloadMessageList()
        self.isLoading = false
    }
}
