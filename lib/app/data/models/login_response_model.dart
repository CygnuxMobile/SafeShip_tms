class LoginResponseModel {
  String? success;
  String? message;
  UserData? response;

  LoginResponseModel({this.success, this.message, this.response});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['Success']?.toString();
    message = json['Message'];
    response = json['Response'] != null ? UserData.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Message'] = message;
    if (response != null) {
      data['Response'] = response!.toJson();
    }
    return data;
  }
}

class UserData {
  String? password;
  String? brachName;
  String? branchCode;
  String? userId;
  String? userType;
  String? message;
  String? qty;
  String? iCode;
  String? iname;
  String? volumeCft;
  String? proposedValueOfGoods;
  String? packingMaterial;
  String? city;
  String? isValid;
  String? status;
  String? value;
  String? text;
  String? menu1;
  String? menu2;
  String? timeslot;
  String? name;
  String? brcd;
  String? locationCode;
  String? version;
  String? companyCode;
  bool? isScannerRight;

  UserData({
    this.password,
    this.brachName,
    this.branchCode,
    this.userId,
    this.userType,
    this.message,
    this.qty,
    this.iCode,
    this.iname,
    this.volumeCft,
    this.proposedValueOfGoods,
    this.packingMaterial,
    this.city,
    this.isValid,
    this.status,
    this.value,
    this.text,
    this.menu1,
    this.menu2,
    this.timeslot,
    this.name,
    this.brcd,
    this.version,
    this.companyCode,
    this.isScannerRight,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    brachName = json['BrachName'];
    branchCode = json['BranchCode'];
    userId = json['UserId'];
    userType = json['User_Type'];
    message = json['Message'];
    qty = json['QTY'];
    iCode = json['ICode'];
    iname = json['Iname'];
    volumeCft = json['Volume_CFT'];
    proposedValueOfGoods = json['ProposedValueOfGoods'];
    packingMaterial = json['Packing_Material'];
    city = json['City'];
    isValid = json['IsValid'];
    status = json['Status'];
    value = json['Value'];
    text = json['Text'];
    menu1 = json['Menu_1'];
    menu2 = json['Menu_2'];
    timeslot = json['Timeslot'];
    name = json['Name'];
    brcd = json['BRCD'];
    locationCode = json['LocationCode'];
    version = json['Version'];
    companyCode = json['COMPANYCODE'];
    isScannerRight = json['IsScannerRight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['BrachName'] = brachName;
    data['BranchCode'] = branchCode;
    data['UserId'] = userId;
    data['User_Type'] = userType;
    data['Message'] = message;
    data['QTY'] = qty;
    data['ICode'] = iCode;
    data['Iname'] = iname;
    data['Volume_CFT'] = volumeCft;
    data['ProposedValueOfGoods'] = proposedValueOfGoods;
    data['Packing_Material'] = packingMaterial;
    data['City'] = city;
    data['IsValid'] = isValid;
    data['Status'] = status;
    data['Value'] = value;
    data['Text'] = text;
    data['Menu_1'] = menu1;
    data['Menu_2'] = menu2;
    data['Timeslot'] = timeslot;
    data['Name'] = name;
    data['BRCD'] = brcd;
    data['LocationCode'] = locationCode;
    data['Version'] = version;
    data['COMPANYCODE'] = companyCode;
    data['IsScannerRight'] = isScannerRight;
    return data;
  }
}
