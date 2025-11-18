import 'dart:convert';

/// Converts a JSON string into a BaseResponse object
BaseResponse baseResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

/// Converts a BaseResponse object into a JSON string
String baseResponseToJson(BaseResponse data) =>
    json.encode(data.toJson());

/// A generic response wrapper for status and message
class BaseResponse {
  BaseResponse({
    this.status,
    this.message,
  });

  /// Factory constructor to create a BaseResponse from JSON
  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    status: json['status'],
    message: json['message'],
  );

  num? status;
  String? message;

  /// Creates a copy of the response with optional overrides
  BaseResponse copyWith({
    num? status,
    String? message,
  }) =>
      BaseResponse(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  /// Converts the response to a JSON map
  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
  };
}