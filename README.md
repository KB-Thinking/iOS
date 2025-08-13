## 1. 프로젝트 개요

- **프로젝트명**: Kb-Thinking (iOS)
- **한줄 소개**: 사용자의 자연어/음성 입력을 분석해 금융 서비스 제공 및 은행 기능/메뉴로 즉시 안내, 궁금증 해결까지 지원하는 대화형 음성 인터페이스
- **핵심 목표**:
    - 낯선 금융 용어·메뉴를 **대화형 인터페이스**로 쉽게 탐색
    - **최소 기능(MVP)** 기준: 음성 인식 → 서버/LLM 질의 → 화면 라우팅 + 음성 안내

---

## 2. iOS 아키텍처 개요

- **아키텍처**: Clean Architecture + MVVM(프레젠테이션) + Coordinator(네비게이션)
- **레이어 분리**
    - **Presentation**: SwiftUI View, ViewModel, 음성/오디오 Manager, 화면 전환(AppCoordinator)
    - **Domain**: Entity, Repository Protocol, UseCase (비즈니스 규칙)
    - **Data**: API Service, DTO, RepositoryImpl (네트워킹/외부 연동)
- **라우팅 전략**: `AppCoordinator`와 `NavigationStack(path:)` 기반, `AppRoute`로 화면 상태를 명시적 관리

> 이점: 테스트 용이(프로토콜/모킹), 기능 확장 시 레이어 간 결합도 최소화
> 

---

## 3. 주요 모듈/폴더 구조 요약

> 실제 폴더 트리를 간결화하여 역할 중심으로 정리했습니다.
> 

### (1) App

- **Adapters/RouteAdapter.swift**: 서버/LLM으로부터 받은 라우팅 키워드를 **내부 `AppRoute`로 변환**
- **Coordinator/AppCoordinator.swift**: 전역 네비게이션 상태(`path`) 관리
- **Kb_ThinkingApp.swift**: 앱 엔트리, DI 컨테이너 초기화 시점

### (2) Presentation

- **Home/View/**: `HomeView`, `AccountCardView`, `TopBar`, `BottomTabView`
- **Home/ViewModel/**: `HomeViewModel` (계좌·배너 등 홈 데이터/상태 관리)
- **Home/Manager/**:
    - `SpeechRecognizerManager`(음성 인식),
    - `SpeechSynthesizerManager`(시스템 TTS),
    - `OpenAITTSPlayer`(OpenAI TTS 결과 재생)
- **LLM Conversation/View/**: `VoiceConversationView` (대화 UI)
- **LLM Conversation/ViewModel/**: `VoiceConversationViewModel` (대화 상태/흐름)
- **Navigation/**: `AppRoute` (라우팅 Enum)
- **TransferLimit/FundDetail**: 단순 뷰(Mock 화면 포함)
- **Common/KBTopNavBar.swift**: 공통 네비게이션 UI

### (3) Domain

- **Home**:
    - `Entity/AccountEntity.swift`,
    - `Repository/AccountRepository.swift` (프로토콜),
    - `UseCase/AccountsUseCase.swift`
- **LLM Conversation**:
    - `Entity/LLMMessageEntity.swift`,
    - `Repository/LLMConversationRepository.swift` (프로토콜),
    - `UseCase/LLMMessageUseCase.swift`
- **Route.swift**: 라우팅 관련 공용 타입(내부 도메인 키워드)

### (4) Data

- **NetWork/Core/**: `APIService`, `Endpoint`, `HTTPMethod`, `NetworkError`
- **NetWork/Services/**: `AccountAPIService`, `LLMConversationAPIService`, `OpenAITTSAPIService`
- **Home/RepositoryImpl/**: `AccountRepositoryImpl`
- **Home/ResponseDTO/**: `AccountDTO`
- **LLM Conversation/RepositoryImpl/**: `LLMConversationRepositoryImpl`
- **LLM Conversation/RequestDTO/ResponseDTO/**: 요청/응답 DTO 모델

### (5) Resources & Config

- **Resources/**: 에셋, 아이콘, 이미지
- **Config.xcconfig**: API 키/환경 변수 분리 (빌드 설정)
- **Mocks & Stubs/**: `HomeMocks`, `LLMMessageMocks` (프로토타입/테스트용 데이터)

---

## 4. 핵심 동작 흐름 (시퀀스)

### 4.1 음성 대화 → 라우팅 → 음성 안내 및 네비게이션

1. `VoiceConversationView`에서 음성 녹음 시작 → `SpeechRecognizerManager`가 텍스트를 인식
2. 인식 텍스트를 `LLMMessageUseCase` → `LLMConversationRepository` → `LLMConversationAPIService`로 전달
3. 서버/LLM 응답(의도, 설명, 다음 액션)을 수신
4. `RouteAdapter`가 응답을 내부 `AppRoute`로 변환 → `AppCoordinator.path`에 push
5. 설명 텍스트는 `SpeechSynthesizerManager`(시스템 TTS) 또는 `OpenAITTSPlayer`(외부 TTS)로 재생

### 4.2 홈 데이터 로딩

`HomeViewModel` → `AccountsUseCase` → `AccountRepositoryImpl` → `AccountAPIService` 순으로 호출, DTO→Entity 매핑 후 View에 반영

---

## 5. 사용 기술 / 프레임워크

| 영역 | 기술 | 용도 |
| --- | --- | --- |
| UI | **SwiftUI** | 선언형 UI, 상태 기반 렌더링 |
| 오디오 | **AVFoundation** | 음성 합성(시스템 TTS), 오디오 세션 |
| 음성 인식 | **Speech Framework** | STT(한국어 지원) |
| 네트워크 | **URLSession** 기반 커스텀 `APIService` | REST 통신, DTO 인코딩/디코딩 |
| 구조 | **Clean Architecture, MVVM, Coordinator** | 테스트/확장성 확보 |
| 설정 | **xcconfig** | API 키/엔드포인트 분리 |

---

## 6. 실행/빌드 방법 (iOS)

1. **요구사항**: Xcode 15+, iOS 17+ (시뮬레이터/디바이스)
2. **권한 설정(Info.plist)**:
    - `NSSpeechRecognitionUsageDescription` (음성 인식 권한 설명)
    - `NSMicrophoneUsageDescription` (마이크 사용)
    - (필요 시) `NSBluetoothPeripheralUsageDescription` 등 오디오 장치 관련 권한
3. **환경 변수**: `Config.xcconfig`에 다음 키 정의
    - `API_BASE_URL = ...`
    - `OPENAI_API_KEY = ...` (외부 TTS/LLM 사용 시)
4. **빌드**: `Kb-Thinking.xcodeproj` 열기 → `Kb-Thinking` 타깃 실행

> 서버 주소/API 키는 소스 외부에서 주입하여(xcconfig) 보안·환경별 분리 유지
> 

---

## 7. 테스트/모킹 방법

- **Mocks & Stubs** 사용: `HomeMocks.swift`, `LLMMessageMocks.swift`
- **Repository DI**: ViewModel/UseCase는 **프로토콜** 의존 → 실제 `RepositoryImpl` 대신 **Mock Repository** 주입 가능
- (선택) `#if DEBUG` 영역에 `MockLLMConversationRepositoryImpl` 구현 후 런타임 스위치

---

## 8. 에러/로깅/안정성

- **NetworkError** 표준화: `invalidURL`, `invalidResponse`, `decodingError`, `serverError` 등 공통 에러 매핑
- **타임아웃/재시도**: `APIService` 레벨에서 타임아웃 및 기본 재시도 정책(필요 시) 적용 가능
- **오디오 세션**: TTS/녹음 충돌 방지(카테고리/모드 설정), 재생 중 중복 발화 `stopSpeaking` 처리

---

## 9. 현재 제한사항(Prototype)과 향후 계획

- **제한사항**:
    - 의도 분류/라우팅 키워드 세트가 제한적 (스키마 고도화 필요)
    - 오류/예외 상황 가이드(오프라인, 권한 거부 등) 최소화 상태
- **향후 계획**:
    - 라우팅 스키마 고도화(메뉴/매개변수 정의), 다국어 STT/TTS 옵션, 대화 히스토리 축약/컨텍스트 유지
    - 접근성(VoiceOver) 및 HIG 가이드 반영한 모션/피드백 강화

---

## 10. 파일별 핵심 역할 (샘플)

- `Presentation/Home/View/HomeView.swift`: 홈 UI, `AppCoordinator`의 `path` 바인딩
- `Presentation/LLM Conversation/View/VoiceConversationView.swift`: 대화 UI, 녹음/전송/응답 표시
- `Presentation/Home/Manager/SpeechRecognizerManager.swift`: STT 권한/세션/전사 콜백
- `Presentation/Home/Manager/SpeechSynthesizerManager.swift`: 시스템 TTS 재생 파라미터(rate, pitch, volume)
- `Data/NetWork/Core/APIService.swift`: 공통 REST 클라이언트, `Endpoint`/`HTTPMethod`
- `Data/.../LLMConversationAPIService.swift`: LLM 질의 API 연동
- `Domain/.../LLMMessageUseCase.swift`: STT 텍스트를 서버/LLM에 전달하고 결과를 ViewModel로 반환
- `App/Adapters/RouteAdapter.swift`: 서버 응답 → `AppRoute` 변환 (예: "이체 한도 변경" → `.limit`)

---
