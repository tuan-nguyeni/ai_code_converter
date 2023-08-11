class ConversionRequest {
  final String source;
  final String target;
  final String code;

  ConversionRequest({
    required this.source,
    required this.target,
    required this.code,
  });

  Map<String, String> toMap() {
    return {
      'source': source,
      'target': target,
      'code': code,
    };
  }
}
