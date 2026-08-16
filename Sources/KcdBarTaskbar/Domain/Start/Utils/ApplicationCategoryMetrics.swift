package enum ApplicationCategoryMetrics {
    package static let rawPrefix = "public.app-category."
    package static let titlePrefix = "start.category."
    package static let gameSuffix = "games"

    package static let byRawSuffix: [String: ApplicationCategory] = [
        "productivity": .productivity,
        "business": .productivity,
        "finance": .productivity,
        "graphics-design": .creativity,
        "photography": .creativity,
        "video": .creativity,
        "music": .creativity,
        "developer-tools": .developer,
        "social-networking": .social,
        "entertainment": .entertainment,
        "sports": .entertainment,
        "utilities": .utilities,
        "tools": .utilities,
        "weather": .utilities,
        "navigation": .utilities,
        "reference": .reference,
        "education": .reference,
        "books": .reference,
        "news": .reference,
    ]
}
