# ChatGPT統合チャット機能 設計ドキュメント

## 目次
1. [概要と目的](#概要と目的)
2. [現状分析](#現状分析)
3. [要求仕様](#要求仕様)
4. [システムアーキテクチャ](#システムアーキテクチャ)
5. [API統合設計](#API統合設計)
6. [ADHD配慮設計](#ADHD配慮設計)
7. [セキュリティとプライバシー](#セキュリティとプライバシー)
8. [コスト管理](#コスト管理)
9. [エラーハンドリング](#エラーハンドリング)
10. [実装計画](#実装計画)

---

## 1. 概要と目的

### 1.1 プロジェクト概要
NaviNaviアプリの既存チャット機能を拡張し、ChatGPT APIを統合することで、タスク管理以外の幅広い質問や会話にも対応可能な汎用的なチャットアシスタントを実現する。

### 1.2 主要目的
- **機能拡張**: タスク認識だけでなく、どんな質問にも応答可能
- **ADHD支援強化**: 認知負荷を考慮したインテリジェントな応答
- **既存機能維持**: タスク管理機能との seamless な統合
- **ユーザビリティ向上**: より自然で人間らしい対話体験

---

## 2. 現状分析

### 2.1 現在の実装
```swift
// 現在のChatViewModel構造
class ChatViewModel: ObservableObject {
    // タスク特化の機能
    - SerenaClient（NLP）を使用したタスク認識
    - 固定的な応答パターン
    - タスク作成・修正に限定された機能
    - 学習システムとの統合
}
```

### 2.2 制限事項
- **応答範囲の限定**: タスク関連の質問のみ対応
- **会話の流れ**: コンテキスト保持が弱い
- **柔軟性の欠如**: 定型的な応答のみ
- **多様な質問への対応不足**: 一般的な質問に答えられない

### 2.3 強みの分析
- **ADHD特化**: 既に認知負荷を考慮したUI設計
- **タスク統合**: 学習システムとの優秀な連携
- **データ構造**: 拡張可能なメッセージ構造

---

## 3. 要求仕様

### 3.1 機能要求

#### 3.1.1 基本チャット機能
- **汎用応答**: どんな質問・会話にも適切に応答
- **コンテキスト保持**: 会話履歴を考慮した一貫性のある応答
- **多言語対応**: 日本語を中心とした自然な対話

#### 3.1.2 タスク管理統合
- **タスク認識**: 会話の中からタスク要素を自動抽出
- **インテリジェントモード切替**: 一般対話とタスク管理の seamless な切り替え
- **既存機能継承**: 現在のタスク学習・提案機能の維持

#### 3.1.3 ADHD特化機能
- **認知負荷軽減**: 簡潔で理解しやすい応答
- **注意散漫対策**: 重要な情報のハイライト
- **実行支援**: 具体的で実行可能なアドバイス

### 3.2 非機能要求

#### 3.2.1 パフォーマンス
- **応答速度**: 5秒以内の応答
- **同期性**: リアルタイムな対話体験
- **メモリ効率**: 適切な会話履歴管理

#### 3.2.2 可用性
- **高可用性**: 99.5%以上の稼働率目標
- **フェイルオーバー**: API障害時のフォールバック機能

#### 3.2.3 拡張性
- **モデル切替**: 将来的な新しいAIモデルへの対応
- **プラグイン対応**: 追加機能の容易な統合

---

## 4. システムアーキテクチャ

### 4.1 全体アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                        ChatView                              │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │
│  │  MessageBubble  │ │  InputArea      │ │  SuggestionChip │ │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   ChatViewModel                              │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              ConversationManager                        │ │
│  │  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────┐ │ │
│  │  │  ChatGPTClient  │ │  TaskExtractor  │ │ ContextMgr  │ │ │
│  │  └─────────────────┘ └─────────────────┘ └─────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │               ADHDOptimizer                             │ │
│  │  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────┐ │ │
│  │  │ ResponseFilter  │ │  CognitiveMgr   │ │ AttentionMgr│ │ │
│  │  └─────────────────┘ └─────────────────┘ └─────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Service Layer                               │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │
│  │  OpenAI API     │ │ TaskLearningInt │ │  CalendarSvc    │ │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 コンポーネント設計

#### 4.2.1 ConversationManager
```swift
@MainActor
class ConversationManager: ObservableObject {
    // 会話統制の中核
    private let chatGPTClient: ChatGPTClient
    private let taskExtractor: TaskExtractor  
    private let contextManager: ContextManager
    private let adhdOptimizer: ADHDOptimizer
    
    // 主要機能
    func processMessage(_ input: String) async -> ChatResponse
    func detectIntent(_ input: String) -> ConversationIntent
    func manageConversationFlow() -> ConversationState
}
```

#### 4.2.2 ChatGPTClient
```swift
class ChatGPTClient {
    // OpenAI API統合
    private let apiKey: String
    private let model: String = "gpt-4-turbo"
    private let rateLimit: RateLimit
    
    func sendMessage(messages: [ChatMessage], systemPrompt: String) async throws -> String
    func streamResponse() async throws -> AsyncStream<String>
}
```

#### 4.2.3 TaskExtractor
```swift
class TaskExtractor {
    // タスク要素の自動抽出
    func extractTasks(from response: String) -> [Task]
    func detectTaskIntent(_ input: String) -> TaskIntent?
    func enhanceTaskWithContext(_ task: Task, context: ConversationContext) -> Task
}
```

#### 4.2.4 ADHDOptimizer
```swift 
class ADHDOptimizer {
    // ADHD配慮の応答最適化
    func optimizeResponse(_ response: String, context: ADHDContext) -> OptimizedResponse
    func reducecognitive Load(_ text: String) -> String
    func highlightImportant(_ text: String) -> HighlightedText
}
```

---

## 5. API統合設計

### 5.1 OpenAI API統合

#### 5.1.1 APIクライアント設計
```swift
protocol ChatAPIClient {
    func sendMessage(messages: [APIMessage]) async throws -> APIResponse
    func streamResponse() async throws -> AsyncStream<String>
}

class OpenAIChatGPTClient: ChatAPIClient {
    private let configuration: OpenAIConfiguration
    private let session: URLSession
    private let rateLimiter: RateLimiter
    
    // エラーハンドリング
    enum APIError: LocalizedError {
        case rateLimitExceeded
        case invalidResponse
        case networkError(Error)
        case authenticationFailed
    }
}
```

#### 5.1.2 システムプロンプト設計
```swift
class SystemPromptManager {
    static let basePrompt = """
    あなたはNaviNaviアプリの ADHD支援に特化したアシスタントです。
    
    【基本方針】
    - 簡潔で理解しやすい回答を心がける
    - 具体的で実行可能なアドバイスを提供
    - 注意散漫を避けるため重要な情報を強調
    - タスク管理の文脈では詳細な時間・手順を提案
    
    【応答形式】
    - 長い文章は避け、箇条書きや段落分けを活用
    - 専門用語は避け、平易な言葉を使用  
    - アクション可能な具体案を優先
    
    【タスク認識】
    ユーザーの入力からタスク要素を検出した場合：
    - タスクタイトル
    - 推定時間
    - 開始時刻（指定があれば）
    - 場所（指定があれば）
    を JSON形式で抽出してください。
    """
    
    func generateContextualPrompt(
        adhdProfile: ADHDProfile, 
        conversationHistory: [ChatMessage],
        currentTasks: [Task]
    ) -> String
}
```

### 5.2 会話コンテキスト管理

#### 5.2.1 コンテキスト保持戦略
```swift
class ContextManager {
    private var conversationHistory: [ChatMessage] = []
    private let maxHistoryCount = 20  // トークン制限考慮
    private let maxTokens = 8000      // GPT-4制限の80%
    
    func addMessage(_ message: ChatMessage)
    func getRelevantHistory() -> [ChatMessage] 
    func pruneOldMessages()  // 古いメッセージの削除
    func summarizeHistory() -> String  // 要約による圧縮
}
```

#### 5.2.2 インテント検出
```swift
enum ConversationIntent {
    case general              // 一般的な会話
    case taskManagement      // タスク関連  
    case adhdSupport        // ADHD支援
    case informationQuery   // 情報照会
    case emotional Support  // 感情的サポート
}

class IntentClassifier {
    func classifyIntent(_ input: String) -> ConversationIntent
    func getIntentConfidence() -> Double
}
```

---

## 6. ADHD配慮設計

### 6.1 認知負荷軽減

#### 6.1.1 応答最適化
```swift
class ResponseOptimizer {
    // 文章簡素化
    func simplifyLanguage(_ text: String) -> String {
        // - 専門用語 → 平易な表現
        // - 長文 → 短文化
        // - 受動態 → 能動態
    }
    
    // 構造化
    func structureResponse(_ text: String) -> StructuredResponse {
        // - 箇条書き化
        // - 段落分け  
        // - 重要度別ハイライト
    }
    
    // 実行可能性向上
    func makeActionable(_ advice: String) -> [Action] {
        // - 抽象的助言 → 具体的ステップ
        // - 「〜すべき」 → 「〜してください」
    }
}
```

#### 6.1.2 注意管理
```swift
class AttentionManager {
    // 重要情報のハイライト
    func highlightKeyInfo(_ text: String) -> HighlightedText
    
    // 情報量制御
    func limitInformationDensity(_ response: String) -> String
    
    // 注意散漫要因の除去
    func removeDistractingElements(_ content: String) -> String
}
```

### 6.2 実行機能支援

#### 6.2.1 タスク分解支援
```swift
class ExecutiveFunctionSupport {
    func breakDownComplexTask(_ task: Task) -> [Task] {
        // 複雑なタスクを小さなステップに分解
    }
    
    func suggestExecutionOrder(_ tasks: [Task]) -> [Task] {
        // 実行順序の提案（優先度・依存関係考慮）
    }
    
    func addTimeBuffers(_ schedule: [Task]) -> [Task] {
        // 予期しない遅延への対応
    }
}
```

#### 6.2.2 記憶支援
```swift
class MemorySupport {
    func createMemoryAids(for task: Task) -> [MemoryAid] {
        // - チェックリスト生成
        // - リマインダー設定提案
        // - 視覚的手がかり提案
    }
    
    func suggestExternalMemory(_ information: String) -> [ExternalMemoryTool] {
        // 外部記憶ツールの活用提案
    }
}
```

---

## 7. セキュリティとプライバシー

### 7.1 データ保護

#### 7.1.1 個人情報保護
```swift
class PrivacyManager {
    // 機密情報検出・フィルタリング
    func detectSensitiveInfo(_ text: String) -> [SensitiveDataType]
    func maskSensitiveData(_ text: String) -> String
    
    // データ匿名化
    func anonymizeForAPI(_ messages: [ChatMessage]) -> [APIMessage]
    
    // ローカルデータ保護
    func encryptLocalHistory(_ history: [ChatMessage]) -> EncryptedData
}

enum SensitiveDataType {
    case personalName
    case phoneNumber  
    case email
    case address
    case financialInfo
}
```

#### 7.1.2 API通信セキュリティ
```swift
class APISecurityManager {
    // API キー管理
    private let keyManager: SecureKeyManager
    
    // 通信暗号化
    func createSecureSession() -> URLSession
    
    // レート制限・DDoS対策
    func enforceRateLimit() -> Bool
    
    // 異常検出
    func detectAbnormalUsage() -> SecurityAlert?
}
```

### 7.2 データ最小化

#### 7.2.1 データ送信制限
```swift
class DataMinimizer {
    // 必要最小限のデータのみ送信
    func minimizeMessageContent(_ message: ChatMessage) -> APIMessage {
        // 個人特定情報の除去
        // 不要なメタデータの削除
    }
    
    // 履歴データの制限
    func limitHistoryData(_ history: [ChatMessage]) -> [ChatMessage] {
        // 最新N件のみ送信
        // 機密情報を含むメッセージの除外
    }
}
```

---

## 8. コスト管理

### 8.1 API利用制限

#### 8.1.1 使用量制御
```swift
class CostManager {
    private var dailyTokenUsage: Int = 0
    private var monthlyTokenUsage: Int = 0
    
    private let limits = UsageLimits(
        dailyTokenLimit: 50000,      // 1日50k tokens
        monthlyTokenLimit: 1000000,  // 月間1M tokens  
        perUserDailyLimit: 5000      // ユーザー当たり5k/day
    )
    
    func checkUsageLimit(tokenCount: Int) -> Bool
    func getRemainingQuota() -> UsageQuota
    func suggestCostOptimization() -> [OptimizationSuggestion]
}
```

#### 8.1.2 効率化戦略
```swift
class EfficiencyOptimizer {
    // レスポンスキャッシュ
    func cacheCommonResponses() 
    
    // バッチ処理
    func batchSimilarRequests() 
    
    // モデル選択最適化
    func selectOptimalModel(for task: ConversationIntent) -> String {
        switch task {
        case .simple: return "gpt-3.5-turbo"    // コスト効率
        case .complex: return "gpt-4-turbo"     // 品質重視
        }
    }
}
```

---

## 9. エラーハンドリング

### 9.1 API障害対応

#### 9.1.1 フォールバック戦略
```swift
class FallbackManager {
    private let fallbackStrategies: [FallbackStrategy] = [
        .cachedResponse,      // キャッシュされた応答
        .templateResponse,    // テンプレート応答
        .localNLP,           // ローカル処理
        .gracefulDegradation // 機能縮小
    ]
    
    func handleAPIFailure(_ error: APIError) -> FallbackResponse
    func selectBestFallback(for context: ConversationContext) -> FallbackStrategy
}
```

#### 9.1.2 ユーザー体験保護
```swift
class ErrorExperienceManager {
    // エラー状況の透明性確保
    func createUserFriendlyErrorMessage(_ error: Error) -> String
    
    // 継続的サービス提供
    func provideLimitedService() -> ServiceMode
    
    // 復旧の自動通知
    func notifyServiceRestoration()
}
```

---

## 10. 実装計画

### 10.1 段階的実装

#### Phase 1: 基盤構築（2-3週間）
- [ ] ChatGPTClient実装
- [ ] 基本的なAPI統合
- [ ] エラーハンドリング基盤
- [ ] セキュリティ基盤

#### Phase 2: コア機能（3-4週間）  
- [ ] ConversationManager実装
- [ ] TaskExtractor統合
- [ ] ADHD最適化機能
- [ ] コンテキスト管理

#### Phase 3: 高度機能（2-3週間）
- [ ] インテント検出
- [ ] フォールバック機能
- [ ] コスト管理
- [ ] パフォーマンス最適化

#### Phase 4: UI/UX改善（1-2週間）
- [ ] 新しいメッセージ型対応
- [ ] ストリーミング応答
- [ ] ローディング状態改善
- [ ] アクセシビリティ向上

### 10.2 テスト戦略

#### 10.2.1 ユニットテスト
```swift
class ChatGPTClientTests: XCTestCase {
    func testAPIRequestFormatting()
    func testErrorHandling() 
    func testRateLimit()
    func testSecurityFiltering()
}

class ADHDOptimizerTests: XCTestCase {
    func testCognitive LoadReduction()
    func testResponseStructuring()
    func testAttentionManagement()
}
```

#### 10.2.2 統合テスト
- API統合テスト
- エンドツーエンドシナリオ
- パフォーマンステスト
- セキュリティテスト

### 10.3 品質保証

#### 10.3.1 ADHD観点の品質評価
- 認知負荷測定
- 理解度テスト  
- 実行可能性評価
- ユーザビリティテスト

#### 10.3.2 技術的品質評価
- 応答速度測定
- API使用効率
- エラー率監視
- セキュリティ監査

---

## 11. 運用とモニタリング

### 11.1 パフォーマンス監視
```swift
class PerformanceMonitor {
    func trackResponseTime()
    func monitorAPIUsage() 
    func measureUserSatisfaction()
    func alertOnAnomalies()
}
```

### 11.2 継続的改善
- ユーザーフィードバック収集
- A/Bテストによる最適化
- ADHD研究の最新知見の反映
- AI技術進歩への対応

---

## 12. まとめ

この設計により、NaviNaviアプリのチャット機能は：

✅ **汎用性**: どんな質問にも適切に応答  
✅ **ADHD配慮**: 認知負荷を考慮した最適化  
✅ **既存統合**: タスク管理機能との seamless な連携  
✅ **安全性**: セキュリティとプライバシーの確保  
✅ **効率性**: コスト効率的な運用  
✅ **信頼性**: 堅牢なエラーハンドリング  

を実現し、ユーザーにとってより価値のあるチャット体験を提供できます。