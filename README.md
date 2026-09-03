# Vitalinguu

Vitalinguu is a cross-platform Flutter language-learning app that uses AI to create personalized practice sessions. Learners choose a language, define their own study topics, select a CEFR level and exercise mix, and receive generated activities with answer feedback, optional audio, and translations.

The app currently uses [NanoGPT](https://nano-gpt.com/) for chat completions, structured exercise generation, and text-to-speech. A NanoGPT API key and paid API credit are required to use the learning flow.

## Features

- Practice English, Spanish (Mexico), German, Portuguese (Brazil), French, or Italian.
- Use any supported language as the interface/native language or learning language.
- Create, edit, bulk import, and delete custom learning topics.
- Generate exercises for CEFR levels A1 through C2.
- Adjust the probability of topics, exercise types, and text/audio prompts with low, medium, or high priorities.
- Choose text-only, audio-only, or mixed prompt sessions.
- Translate exercise instructions and content into the learner's native language on demand.
- Generate spoken prompts and dialogue responses with configurable playback speed.
- Evaluate answers and provide targeted explanations.
- Save topic-level learning feedback and use recent mistakes to shape future sessions.
- Store the API key and user settings in platform secure storage.
- Store topics and assessment history locally with Hive.
- Display and refresh the remaining NanoGPT credit balance.
- Recover from common AI authentication, usage-limit, request, and temporary errors.

## Exercise types

Vitalinguu can generate nine kinds of practice:

| Type | Description | Audio prompt support |
| --- | --- | :---: |
| Dialogue | An interactive AI conversation with per-message feedback | Yes |
| Fill in the blanks | Complete missing words in a passage | No |
| Match elements | Pair related items | No |
| Multiple choice | Select one correct answer | Yes |
| Multiple-choice list | Answer several multiple-choice items | Yes |
| Select all that apply | Select every valid option | Yes |
| Word ordering | Arrange words into the correct order | No |
| Write | Produce a free-form written response | Yes |
| Write a list | Answer a group of related writing prompts | Yes |

## How it works

1. On first launch, select a native language and a language to learn.
2. Enter a NanoGPT API key. Vitalinguu validates it before saving it.
3. Open the **Topics** tab and add at least one subject to practice.
4. In **Configuration**, select a CEFR level, exercise count, prompt format, exercise types, topics, and their priorities.
5. Vitalinguu plans the session, generates schema-validated exercises, and creates any requested audio.
6. Complete the exercises. The app evaluates open-ended answers with AI and checks deterministic exercise types locally where appropriate.
7. At the end of the session, Vitalinguu summarizes mistakes by topic and stores those notes locally. Recent notes can guide later exercise generation.

Priority weights are `1` for low, `2` for medium, and `4` for high. They influence random selection; they do not guarantee an exact distribution.

## Requirements

- Flutter on the stable channel with a Dart SDK compatible with `^3.11.5`.
- The platform toolchain for the target you want to run: Android, iOS, Linux, macOS, or Windows.
- A NanoGPT account, API key, and internet connection.
- More than USD 0.10 in NanoGPT credit. The app disables session generation at or below that balance.
- Android SDK 37 when building the Android target (`flutter_secure_storage` 11.x requires it in this project).

The repository contains native runner projects for Android, iOS, Linux, macOS, and Windows. A web target is not currently configured.

## Getting started

Clone the repository and enter its directory:

```bash
git clone <repository-url>
cd vitalinguu
```

Install dependencies:

```bash
flutter pub get
```

Check the available devices and run the app:

```bash
flutter devices
flutter run -d <device-id>
```

No API key needs to be placed in the source tree or supplied as a build-time environment variable. The app requests it during onboarding and saves it with `flutter_secure_storage`.

## Adding topics

Topics belong to the currently selected learning language. Each topic has a title and a description of the learning objective or content to practice.

The bulk-entry form uses `~` before each title and `^` before its content:

```text
~Travel^Airport vocabulary and asking for directions~Food^Phrases for ordering at a restaurant
```

Changing the learning language shows the separate topic collection associated with that language.

## Configuration

The settings screen allows users to:

- Replace and validate the NanoGPT API key.
- Change the native and learning languages.
- Set the feedback-history window from 1 to 60 days (30 by default).
- Set speech-generation speed from 0.6x to 2.0x (1.0x by default).
- Refresh the available NanoGPT credit balance.

Changing either language restarts the app's setup flow so language-specific dependencies and topics can be reloaded.

## Architecture

The codebase follows a feature-oriented structure with presentation, domain, and data responsibilities separated where useful:

```text
lib/
├── core/
│   ├── data/                 # NanoGPT, audio, and Hive implementations
│   ├── domain/               # Interfaces, shared models, DI, session, and errors
│   └── presentation/         # Router, shell, and shared UI
├── exercise/
│   ├── exercise_view/        # Exercise state, evaluators, and widgets
│   ├── fetch_exercises/      # AI planning and exercise generators
│   ├── fetch_topics_feedback/ # End-of-session feedback generation
│   ├── tab/                  # Session configuration and topic management
│   └── topics_feedback/      # Completed-session screen
├── i18n/                     # Slang translation sources and generated output
├── settings/                 # Persisted configuration and settings UI
├── splash/                   # Onboarding and startup routing
└── main.dart                 # Application entry point
```

Key design choices:

- **Dependency injection:** `get_it` registers base services at startup and session-specific AI/language dependencies after onboarding.
- **Reactive state:** `signals` exposes view-model state to Flutter widgets.
- **Navigation:** `auto_route` defines onboarding, tab, generation, exercise, and feedback routes.
- **Structured AI output:** exercise planners, generators, and evaluators use JSON schemas and validate model responses before mapping them to domain objects.
- **Persistence:** `flutter_secure_storage` holds settings and the API key; Hive CE stores topics and topic assessments.
- **Localization:** `slang` generates strongly typed translations from the JSON locale files.

## AI services and data flow

The current implementation calls NanoGPT endpoints directly from the client:

| Capability | Current model/service |
| --- | --- |
| Planning, generation, evaluation, and translation | `inception/mercury-2.5-preview` |
| Text-to-speech | `inworld-tts-1.5-mini`, voice `Dennis` |
| API-key validation and credit balance | NanoGPT balance API |

Topics, generated-session context, learner answers, and feedback requests may be sent to NanoGPT to provide the requested features. The API key is stored in the operating system's secure storage, while topics and assessment notes remain in the app's local Hive database. Review NanoGPT's terms and privacy policy before using the app with sensitive content.

There is also a NanoGPT speech-to-text adapter in the data layer, but the current interface does not record or submit microphone audio.

## Main dependencies

| Package | Purpose |
| --- | --- |
| `auto_route` | Declarative navigation and generated routes |
| `get_it` | Dependency injection and service location |
| `signals` | Reactive application and view-model state |
| `http` | NanoGPT API communication |
| `flutter_secure_storage` | Secure settings and API-key persistence |
| `hive_ce` / `hive_ce_flutter` | Local topic and assessment storage |
| `audioplayers` | Playback of generated speech |
| `slang` / `slang_flutter` | Type-safe localization |
| `decimal` | Exact API credit-balance values |
| `uuid` | Topic identifiers |

## Localization

The UI is available in:

- English (`en`)
- Spanish, Mexico (`es-MX`)
- German (`de`)
- Portuguese, Brazil (`pt-BR`)
- French (`fr`)
- Italian (`it`)

English is the base locale. Translation source files live in `lib/i18n`, and `slang.yaml` contains the generator configuration.

## License

Copyright (C) 2026 Adrian Rivera Luna.

Vitalinguu is free software licensed under the GNU General Public License, version 3 or, at your option, any later version. See [LICENSE](LICENSE) for the full terms.
