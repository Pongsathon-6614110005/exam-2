import 'package:json_annotation/json_annotation.dart';

part 'llm_response_model.g.dart';

@JsonSerializable()
class GeminiResponse {
  final List<GeminiCandidate>? candidates;

  GeminiResponse({this.candidates});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) => _$GeminiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeminiResponseToJson(this);
}

@JsonSerializable()
class GeminiCandidate {
  final String? output;

  GeminiCandidate({this.output});

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) => _$GeminiCandidateFromJson(json);
  Map<String, dynamic> toJson() => _$GeminiCandidateToJson(this);
}
