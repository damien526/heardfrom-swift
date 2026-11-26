# HeardFrom

One question shown once after onboarding: "How did you hear about us?". Answers feed [Dailyreel](https://www.dailyreel.app)'s attribution, the most honest signal for organic TikTok and Instagram content.

## Install

Xcode: File > Add Package Dependencies, then `https://github.com/damien526/heardfrom-swift` (from 1.0.0).

Or in `Package.swift`:

```swift
.package(url: "https://github.com/damien526/heardfrom-swift", from: "1.0.0")
```

## Use

```swift
import HeardFrom

HeardFrom.configure(key: "<your app key from Dailyreel, Integrations>")

if !HeardFrom.hasAnswered {
    HeardFromView { _ in /* continue onboarding */ }
}
```

Not using SwiftUI or Swift? Send one request yourself (Flutter, React Native…):

```
POST https://www.dailyreel.app/api/survey
Content-Type: application/json

{ "key": "<app key>", "answer": "tiktok" | "instagram" | "app_store_search" | "friend" | "youtube" | "other", "detail": "optional, 200 chars max" }
```

iOS 16+, Swift 6. MIT licence.
