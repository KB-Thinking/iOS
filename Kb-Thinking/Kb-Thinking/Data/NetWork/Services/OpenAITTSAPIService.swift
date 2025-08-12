//
//  OpenAITTSAPIService.swift
//  Kb-Thinking
//
//  Created by GPT on 2025-08-11.
//

import Foundation

protocol OpenAITTSAPIServiceProtocol {
    func synthesize(
        text: String,
        model: String,
        voice: String,
        format: String
    ) async throws -> Data
}

struct OpenAITTSAPIService: OpenAITTSAPIServiceProtocol {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    //Supported values are: 'alloy', 'echo', 'fable', 'onyx'**, 'nova', 'shimmer', 'coral', 'verse', 'ballad', 'ash**', and 'sage**'.",
    func synthesize(
        text: String,
        model: String = "gpt-4o-mini-tts",
        voice: String = "onyx ",
        format: String = "mp3"
    ) async throws -> Data {
        guard let url = URL(string: "https://api.openai.com/v1/audio/speech") else {
            throw NSError(domain: "OpenAITTS", code: -1, userInfo: [NSLocalizedDescriptionKey: "잘못된 URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "model": model,
            "input": text,
            "voice": voice,
            "format": format
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "OpenAITTS", code: -2, userInfo: [NSLocalizedDescriptionKey: "TTS 실패: \(message)"])
        }
        return data
    }
} 
