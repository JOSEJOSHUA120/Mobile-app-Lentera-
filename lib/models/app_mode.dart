enum AppMode { basic, ai }

extension AppModeLabel on AppMode {
  String get label => switch (this) {
    AppMode.basic => 'Mode Dasar',
    AppMode.ai => 'Mode AI',
  };
}
