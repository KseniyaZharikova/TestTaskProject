import Foundation

protocol MessagesViewDelegate: NSObjectProtocol {
    func updateMessageListAfterJump()
    func updateMessageList()
    func reloadMessageList()
}
