class VersionResponse {
  String? getAPKVersionResult;

  VersionResponse({this.getAPKVersionResult});

  VersionResponse.fromJson(Map<String, dynamic> json) {
    getAPKVersionResult = json['GetAPKVersionResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GetAPKVersionResult'] = getAPKVersionResult;
    return data;
  }
}
