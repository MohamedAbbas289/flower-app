class CheckoutSessionResponseModel {
  final String? message;
  final String? sessionId;
  final String? sessionUrl;

  const CheckoutSessionResponseModel({
    this.message,
    this.sessionId,
    this.sessionUrl,
  });

  factory CheckoutSessionResponseModel.fromJson(Map<String, dynamic> json) {
    final session = json['session'] as Map<String, dynamic>?;
    return CheckoutSessionResponseModel(
      message: json['message'] as String?,
      sessionId: session?['id'] as String?,
      sessionUrl: session?['url'] as String?,
    );
  }
}
