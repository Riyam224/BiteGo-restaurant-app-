class EnvConfig {
  EnvConfig._();

  static const String apiKey = String.fromEnvironment(
    'RESTAURANT_API_KEY',
    defaultValue: '',
  );

  static void validate() {
    if (apiKey.isEmpty) {
      throw Exception(
        'RESTAURANT_API_KEY is not set. Please create a .env file with your API key.',
      );
    }
  }
}
