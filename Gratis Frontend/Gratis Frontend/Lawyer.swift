////mport the framework in your project:
//
//import OpenAISwift
//
//Create an OpenAI API key and add it to your configuration:
//
//let openAI = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: MY SECRET KEY))
//
//This framework supports Swift concurrency; each example below has both an async/await and completion handler variant.
//
//Completions
//
//Predict completions for input text.
//
//openAI.sendCompletion(with: "Hello how are you") { result in // Result<OpenAI, OpenAIError>
//    switch result {
//    case .success(let success):
//        print(success.choices.first?.text ?? "")
//    case .failure(let failure):
//        print(failure.localizedDescription)
//    }
//}
//This returns an OpenAI object containing the completions.
//
//Other API parameters are also supported:
//
//do {
//    let result = try await openAI.sendCompletion(
//        with: "What's your favorite color?",
//        model: .gpt3(.davinci), // optional `OpenAIModelType`
//        maxTokens: 16,          // optional `Int?`
//        temperature: 1          // optional `Double?`
//    )
//    // use result
//} catch {
//    // ...
//}
//For a full list of supported models, see OpenAIModelType.swift. For more information on the models see the OpenAI API Documentation.
//
//Chat
//
//Get responses to chat conversations through ChatGPT (aka GPT-3.5) and GPT-4 (in beta).
//
//do {
//    let chat: [ChatMessage] = [
//        ChatMessage(role: .system, content: "You are a helpful assistant."),
//        ChatMessage(role: .user, content: "Who won the world series in 2020?"),
//        ChatMessage(role: .assistant, content: "The Los Angeles Dodgers won the World Series in 2020."),
//        ChatMessage(role: .user, content: "Where was it played?")
//    ]
//
//    let result = try await openAI.sendChat(with: chat)
//    // use result
//} catch {
//    // ...
//}
//All API parameters are supported, except streaming message content before it is completed:
//
//do {
//    let chat: [ChatMessage] = [...]
//
//    let result = try await openAI.sendChat(
//        with: chat,
//        model: .chat(.chatgpt),         // optional `OpenAIModelType`
//        user: nil,                      // optional `String?`
//        temperature: 1,                 // optional `Double?`
//        topProbabilityMass: 1,          // optional `Double?`
//        choices: 1,                     // optional `Int?`
//        stop: nil,                      // optional `[String]?`
//        maxTokens: nil,                 // optional `Int?`
//        presencePenalty: nil,           // optional `Double?`
//        frequencyPenalty: nil,          // optional `Double?`
//        logitBias: nil                 // optional `[Int: Double]?` (see inline documentation)
//    )
//    // use result
//} catch {
//    // ...
//}
//Images (DALL·E)
//
//Generate an image based on a prompt.
//
//openAI.sendImages(with: "A 3d render of a rocket ship", numImages: 1, size: .size1024) { result in // Result<OpenAI, OpenAIError>
//    switch result {
//    case .success(let success):
//        print(success.data.first?.url ?? "")
//    case .failure(let failure):
//        print(failure.localizedDescription)
//    }
//}
//Edits
//
//Edits text based on a prompt and an instruction.
//
//do {
//    let result = try await openAI.sendEdits(
//        with: "Improve the tone of this text.",
//        model: .feature(.davinci),               // optional `OpenAIModelType`
//        input: "I am resigning!"
//    )
//    // use result
//} catch {
//    // ...
//}
//Moderation
//
//Classifies text for moderation purposes (see OpenAI reference for more info).
//
//do {
//    let result = try await openAI.sendModeration(
//        with: "Some harmful text...",
//        model: .moderation(.latest)     // optional `OpenAIModelType`
//    )
//    // use result
//} catch {
//    // ...
//}
//Embeddings
//
//Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.(see OpenAI reference for more info).
//
//do {
//    let result = try await openAI.sendEmbeddings(
//        with: "The food was delicious and the waiter..."
//    )
//    // use result
//} catch {
//    // ...
//}
//Contribute ❤️
//
//I created this mainly for fun, we can add more endpoints and explore the library even further. Feel free to raise a PR to help grow the library.
//
//
