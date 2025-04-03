import Testing
@testable import KeyChainModule

// 테스트 실행 전 상태를 초기화하기 위한 헬퍼 함수
func cleanKeychain() {
    KeyChainModule.delete(key: .accessToken)
    KeyChainModule.delete(key: .refreshToken)
    KeyChainModule.delete(key: .isLogin)
}

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func testCreateAndReadAccessToken() async throws {
    cleanKeychain()
    
    let testToken = "testAccessToken"
    KeyChainModule.create(key: .accessToken, data: testToken)
    
    let readToken = KeyChainModule.read(key: .accessToken)
    #expect(readToken == testToken, "읽은 토큰은 생성한 토큰과 같아야 합니다.")
}

@Test func testUpdateAccessToken() async throws {
    let initialToken = "initialToken"
    let updatedToken = "updatedToken"
    
    // 초기 토큰 생성
    KeyChainModule.create(key: .accessToken, data: initialToken)
    // 동일 키로 다시 create 호출 시 update 로직이 실행됨
    KeyChainModule.create(key: .accessToken, data: updatedToken)
    
    let readToken = KeyChainModule.read(key: .accessToken)
    #expect(readToken == updatedToken, "업데이트된 토큰이 읽혀져야 합니다.")
}

@Test func testDeleteAccessToken() async throws {
    let testToken = "testAccessToken"
    KeyChainModule.create(key: .accessToken, data: testToken)
    
    // 생성한 토큰 삭제
    KeyChainModule.delete(key: .accessToken)
    
    let readToken = KeyChainModule.read(key: .accessToken)
    #expect(readToken == nil, "삭제 후 토큰은 nil이어야 합니다.")
}
