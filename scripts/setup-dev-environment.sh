#!/bin/bash

# NaviNavi Development Environment Setup Script
# This script sets up the development environment for NaviNavi project

set -e  # Exit on any error

echo "🚀 NaviNavi開発環境セットアップを開始します..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "このスクリプトはmacOSでのみ動作します"
    exit 1
fi

print_info "システム情報を確認しています..."
echo "OS: $(sw_vers -productName) $(sw_vers -productVersion)"
echo "Architecture: $(uname -m)"

# Check Xcode installation
print_info "Xcodeのインストール状況を確認しています..."
if command -v xcodebuild >/dev/null 2>&1; then
    XCODE_VERSION=$(xcodebuild -version | head -1)
    print_status "Xcodeが見つかりました: $XCODE_VERSION"
    
    # Check if Xcode Command Line Tools are installed
    if xcode-select -p >/dev/null 2>&1; then
        print_status "Xcode Command Line Toolsが設定されています"
    else
        print_warning "Xcode Command Line Toolsが設定されていません"
        echo "次のコマンドを実行してください: sudo xcode-select --install"
    fi
else
    print_error "Xcodeがインストールされていません"
    echo "App StoreからXcodeをインストールしてください"
    exit 1
fi

# Check Homebrew installation
print_info "Homebrewのインストール状況を確認しています..."
if command -v brew >/dev/null 2>&1; then
    print_status "Homebrewが見つかりました: $(brew --version | head -1)"
    
    # Update Homebrew
    print_info "Homebrewを更新しています..."
    brew update
    print_status "Homebrew更新完了"
else
    print_warning "Homebrewがインストールされていません"
    echo "Homebrewをインストールしますか？ (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_info "Homebrewをインストールしています..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_status "Homebrew インストール完了"
    else
        print_error "Homebrewが必要です。手動でインストールしてください。"
        exit 1
    fi
fi

# Install development tools
print_info "開発ツールをインストールしています..."

# Install SwiftLint
if command -v swiftlint >/dev/null 2>&1; then
    print_status "SwiftLintが既にインストールされています: $(swiftlint version)"
else
    print_info "SwiftLintをインストールしています..."
    brew install swiftlint
    print_status "SwiftLint インストール完了"
fi

# Install SwiftFormat (optional)
if command -v swiftformat >/dev/null 2>&1; then
    print_status "SwiftFormatが既にインストールされています"
else
    echo "SwiftFormatをインストールしますか？ (コードフォーマッター) (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        brew install swiftformat
        print_status "SwiftFormat インストール完了"
    fi
fi

# Install dependency-check for security scanning
if command -v dependency-check >/dev/null 2>&1; then
    print_status "dependency-checkが既にインストールされています"
else
    echo "dependency-check（セキュリティスキャン）をインストールしますか？ (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        brew install dependency-check
        print_status "dependency-check インストール完了"
    fi
fi

# Install xcpretty for better build output
if command -v xcpretty >/dev/null 2>&1; then
    print_status "xcprettyが既にインストールされています"
else
    echo "xcpretty（ビルド出力整形）をインストールしますか？ (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        gem install xcpretty
        print_status "xcpretty インストール完了"
    fi
fi

# Setup project
print_info "プロジェクトを設定しています..."

# Check if we're in the right directory
if [[ ! -f "NaviNavi/Package.swift" ]]; then
    print_error "NaviNavi/Package.swiftが見つかりません。プロジェクトルートで実行してください。"
    exit 1
fi

# Resolve Swift Package Manager dependencies
print_info "Swift Package Managerの依存関係を解決しています..."
cd NaviNavi
swift package resolve
print_status "依存関係の解決完了"

# Check Xcode project
print_info "Xcodeプロジェクトを確認しています..."
xcodebuild -list
print_status "Xcodeプロジェクト確認完了"

cd ..

# Run initial code quality check
print_info "初期コード品質チェックを実行しています..."
chmod +x scripts/swiftlint.sh
if ./scripts/swiftlint.sh; then
    print_status "SwiftLintチェック完了"
else
    print_warning "SwiftLintでいくつかの問題が検出されました。後で確認してください。"
fi

# Create environment configuration
print_info "環境設定を作成しています..."

# Create .env file if it doesn't exist
if [[ ! -f ".env" ]]; then
    if [[ -f ".env.example" ]]; then
        cp .env.example .env
        print_status ".envファイルを作成しました（.env.exampleからコピー）"
        print_info "必要に応じて.envファイルを編集してください"
    else
        cat > .env << EOF
# NaviNavi Development Environment Configuration

# Supabase Configuration (Optional - will use mock data if not configured)
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_ANON_KEY=your-anon-key-here

# Development Settings
USE_MOCK_DATA=true
DEBUG_LOGGING=true

# Voice Navigation Settings
VOICE_LANGUAGE=ja-JP
VOICE_SPEED=1.0
EOF
        print_status ".envファイルを作成しました"
    fi
else
    print_status ".envファイルが既に存在します"
fi

# Create git hooks directory if it doesn't exist
if [[ ! -d ".git/hooks" ]]; then
    mkdir -p .git/hooks
fi

# Create pre-commit hook
if [[ ! -f ".git/hooks/pre-commit" ]]; then
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for NaviNavi

echo "🔍 Pre-commit checks..."

# Run SwiftLint
if command -v swiftlint >/dev/null 2>&1; then
    echo "Running SwiftLint..."
    if ! ./scripts/swiftlint.sh; then
        echo "❌ SwiftLint failed. Please fix the issues before committing."
        exit 1
    fi
    echo "✅ SwiftLint passed"
else
    echo "⚠️  SwiftLint not found. Install with: brew install swiftlint"
fi

# Check for TODO/FIXME in staged files
if git diff --cached --name-only | grep -E '\.(swift|m|h)$' | xargs grep -l "TODO\|FIXME" >/dev/null 2>&1; then
    echo "⚠️  Found TODO/FIXME in staged files:"
    git diff --cached --name-only | grep -E '\.(swift|m|h)$' | xargs grep -n "TODO\|FIXME"
    echo "Consider resolving these before committing."
fi

echo "✅ Pre-commit checks completed"
EOF
    chmod +x .git/hooks/pre-commit
    print_status "pre-commitフックを作成しました"
else
    print_status "pre-commitフックが既に存在します"
fi

# Run initial tests to verify setup
print_info "初期テストを実行して設定を確認しています..."
cd NaviNavi
if xcodebuild test -scheme NaviNavi -destination 'platform=iOS Simulator,name=iPhone 15' CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO; then
    print_status "初期テストが成功しました"
else
    print_warning "初期テストが失敗しました。設定を確認してください。"
fi
cd ..

# Final summary
echo ""
echo "🎉 NaviNavi開発環境のセットアップが完了しました！"
echo ""
echo "📋 セットアップされた内容:"
echo "  ✅ Xcode & Command Line Tools"
echo "  ✅ Homebrew & 開発ツール"
echo "  ✅ SwiftLint"
echo "  ✅ Swift Package依存関係"
echo "  ✅ 環境設定ファイル (.env)"
echo "  ✅ Git hooks"
echo "  ✅ 初期テスト"
echo ""
echo "🚀 開発を始める準備ができました！"
echo ""
echo "💡 次のステップ:"
echo "  1. Xcodeでプロジェクトを開く: open NaviNavi/NaviNavi.xcodeproj"
echo "  2. 必要に応じて.envファイルを編集"
echo "  3. Supabase設定（本番環境の場合）"
echo "  4. GitHub Actionsのシークレット設定（CI/CD用）"
echo ""
echo "📚 詳細情報:"
echo "  - README.md: プロジェクト概要"
echo "  - NaviNavi/CONTRIBUTING.md: 開発ガイドライン"
echo "  - .github/workflows/: CI/CDパイプライン"
echo ""

print_status "開発環境セットアップが正常に完了しました 🎉"