# 🔐 KeyChainModule

**KeyChainModule**은 Swift로 작성된 가볍고 사용하기 쉬운 키체인 관리 모듈입니다.  
이 모듈은 키체인에 대한 기본적인 CRUD(생성, 읽기, 업데이트, 삭제) 기능과 에러 처리를 제공합니다.

## 주요 기능

- **CRUD 기능:** 키체인 항목을 생성, 읽기, 업데이트, 삭제할 수 있습니다.
- **타입 안전성:** `[CFString: Any]` 딕셔너리를 사용하여 키의 타입이 명확하게 관리됩니다.
- **에러 처리:** 데이터 인코딩 실패 및 키체인 작업 실패 시 `KeyChainError`를 throw하여 호출 측에서 에러를 처리할 수 있습니다.
- **Enum 기반 키 관리:** `Key` enum을 사용하여 관리할 키들을 타입 안전하게 정의합니다.

## 요구 사항

- iOS 10.0 이상 / macOS 10.12 이상 (필요에 따라 조정)
- Swift 5+

## 설치

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/KeyChainModule.git", from: "1.0.2")
]
