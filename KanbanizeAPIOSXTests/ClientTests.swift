
import XCTest
@testable import KanbanizeAPI

class ClientTests: XCTestCase {
  func testAPIKeyLogin() {
    let loggedIn = expectationWithDescription("Logged In")
    client().login {
      if case .Success = $0 {
        loggedIn.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(0, handler: nil)
  }
  
  func testEmailPasswordLogin() {
    let loggedIn = expectationWithDescription("Logged In")
    client((email: validEmail, password: validPassword)).login {
      if case .Success = $0 {
        loggedIn.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func testInvalidEmailLogin() {
    let apiError = expectationWithDescription("API Error")
    client((email: "", password: "")).login {
      if case .Failure(ClientError.APIError) = $0 {
        apiError.fulfill()
      }
    }
    
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func testLogTime() {
    let c = client()
    let timeLogged = expectationWithDescription("Time Logged")
    c.login { result in
      try! c.logTime(LoggedTime(hours: 1),
        taskID: TaskID(46), completion: { result in
          switch result {
          case .Success(let logTimeInfo):
            print(logTimeInfo)
            timeLogged.fulfill()
          case .Failure(let error):
            print(error)
          }
      })
    }
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func testAddComment() {
    let c = client()
    let commentAdded = expectationWithDescription("Comment Added")
    c.login { result in
      try! c.addComment("A Comment",
        taskID: TaskID(46), completion: { result in
          switch result {
          case .Success(let logTimeInfo):
            print(logTimeInfo)
            commentAdded.fulfill()
          case .Failure(let error):
            print(error)
          }
      })
    }
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func client(passwordLogin: (email: String, password: String)? = nil) -> KanbanizeAPI.Client {
    if let login = passwordLogin {
      return Client(subdomain: subdomain,
                    loginInfo: .Password(email: login.email, password: login.password))
    }
    return Client(subdomain: subdomain, loginInfo: .APIKey(apiKey))
  }
  
}
