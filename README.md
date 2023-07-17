## Custom Video Player

This project is a custom video player built using the Flutter framework. It allows you to play videos from a provided URL and provides additional functionality such as controlling playback, displaying countdown timers, and showing buttons with randomized phrases.

### Features

- Play videos from a specified URL.
- Control video playback, including play/pause, rewind, and fast-forward.
- Display a countdown timer that starts when the video finishes playing.
- Show buttons with randomized phrases.

### Dependencies

The project relies on the following dependencies:

- `chewie`: A video player widget for Flutter that provides a customizable UI.
- `video_player`: A Flutter plugin for displaying videos using the platform's video player.
- `flutter`: The Flutter framework for building cross-platform applications.

### Getting Started

To use this video player in your Flutter project, follow these steps:

1. Add the project's dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  chewie: ^1.2.2
  video_player: ^2.1.10
```

2. Import the required packages in your Dart file:

```dart
import 'dart:async';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
```

3. Create a new instance of `CustomVideoPlayer` and provide the video URL and button phrases:

```dart
CustomVideoPlayer(
  videoUrl: 'https://example.com/video.mp4',
  buttonPhrases: [
    'Phrase 1',
    'Phrase 2',
    'Phrase 3',
    'Phrase 4',
    'Phrase 5',
    'Phrase 6',
  ],
),
```

4. Run your Flutter application and enjoy the custom video player functionality!

### Acknowledgements

This project was created using Flutter, an open-source UI software development kit created by Google. The video playback functionality is provided by the `chewie` and `video_player` packages, which are maintained by the Flutter community.

### License

This project is licensed under the [MIT License](LICENSE). Feel free to modify and use the code according to your needs.
