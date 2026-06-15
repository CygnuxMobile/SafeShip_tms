class GetLocationResponse {
  int? locLevel;
  int? reportLevel;
  String? locCode;
  String? locName;
  String? reportLoc;
  String? locAddr;
  String? locState;
  String? locCity;
  String? locPincode;
  String? locSTDCode;
  String? locTelno;
  String? locFaxno;
  String? locmobile;
  String? locEmail;
  String? locAccount;
  String? activeFlag;
  String? opBkg;
  String? opDly;
  String? opTranship;
  String? outSourceOwn;
  String? octroiIO;
  String? airService;
  String? railService;
  String? defaultNextLoc;
  String? nearestPrevLoc;
  String? cutOffYN;
  String? bkgCutOffTime;
  String? docketGenAuto;
  String? locAbbrev;
  String? locRegion;
  String? oPStartdt;
  String? oPEnddt;
  String? computerised;
  String? dataentry;
  String? locStartdt;
  String? locEnddt;
  String? paymentType;
  String? deliveryType;
  String? uPDTBY;
  String? uPDTON;
  String? dKTPFX;
  String? modeSurface;
  String? modeSea;
  String? pickupDoor;
  String? pickupGodown;
  String? billedAt;
  String? vol;
  String? cODDOD;
  String? oDA;
  String? octroiArea;
  String? dlyStartDt;
  String? dlyEndDt;
  String? transshipmentStartDt;
  String? transshipmentEndDt;
  String? cPC;
  String? cnPrefixcode;
  String? oPUGD;
  int? locid;
  String? deliveryControlLoc;
  String? barcodeScanAllowed;
  bool? isPeritNoReq;
  bool? isKeyNoReq;
  String? latitude;
  String? longitude;
  bool? isVirtualLocation;
  String? locNameLocCode;
  String? locAddrLat;
  String? locAddrLng;
  String? acccode;
  String? column1;
  String? accdesc;
  String? locStartdtStr;
  String? locEnddtStr;
  String? city;
  String? cityName;

  GetLocationResponse(
      {this.locLevel,
      this.reportLevel,
      this.locCode,
      this.locName,
      this.reportLoc,
      this.locAddr,
      this.locState,
      this.locCity,
      this.locPincode,
      this.locSTDCode,
      this.locTelno,
      this.locFaxno,
      this.locmobile,
      this.locEmail,
      this.locAccount,
      this.activeFlag,
      this.opBkg,
      this.opDly,
      this.opTranship,
      this.outSourceOwn,
      this.octroiIO,
      this.airService,
      this.railService,
      this.defaultNextLoc,
      this.nearestPrevLoc,
      this.cutOffYN,
      this.bkgCutOffTime,
      this.docketGenAuto,
      this.locAbbrev,
      this.locRegion,
      this.oPStartdt,
      this.oPEnddt,
      this.computerised,
      this.dataentry,
      this.locStartdt,
      this.locEnddt,
      this.paymentType,
      this.deliveryType,
      this.uPDTBY,
      this.uPDTON,
      this.dKTPFX,
      this.modeSurface,
      this.modeSea,
      this.pickupDoor,
      this.pickupGodown,
      this.billedAt,
      this.vol,
      this.cODDOD,
      this.oDA,
      this.octroiArea,
      this.dlyStartDt,
      this.dlyEndDt,
      this.transshipmentStartDt,
      this.transshipmentEndDt,
      this.cPC,
      this.cnPrefixcode,
      this.oPUGD,
      this.locid,
      this.deliveryControlLoc,
      this.barcodeScanAllowed,
      this.isPeritNoReq,
      this.isKeyNoReq,
      this.latitude,
      this.longitude,
      this.isVirtualLocation,
      this.locNameLocCode,
      this.locAddrLat,
      this.locAddrLng,
      this.acccode,
      this.column1,
      this.accdesc,
      this.locStartdtStr,
      this.locEnddtStr,
      this.city,
      this.cityName});

  GetLocationResponse.fromJson(Map<String, dynamic> json) {
    locLevel = json['Loc_Level'];
    reportLevel = json['Report_Level'];
    locCode = json['LocCode'];
    locName = json['LocName'];
    reportLoc = json['Report_Loc'];
    locAddr = json['LocAddr'];
    locState = json['LocState'];
    locCity = json['LocCity'];
    locPincode = json['LocPincode'];
    locSTDCode = json['LocSTDCode'];
    locTelno = json['LocTelno'];
    locFaxno = json['LocFaxno'];
    locmobile = json['Locmobile'];
    locEmail = json['LocEmail'];
    locAccount = json['Loc_Account'];
    activeFlag = json['ActiveFlag'];
    opBkg = json['Op_Bkg'];
    opDly = json['Op_Dly'];
    opTranship = json['Op_Tranship'];
    outSourceOwn = json['OutSource_Own'];
    octroiIO = json['Octroi_IO'];
    airService = json['AirService'];
    railService = json['RailService'];
    defaultNextLoc = json['Default_NextLoc'];
    nearestPrevLoc = json['Nearest_PrevLoc'];
    cutOffYN = json['CutOff_YN'];
    bkgCutOffTime = json['Bkg_CutOffTime'];
    docketGenAuto = json['DocketGen_Auto'];
    locAbbrev = json['LocAbbrev'];
    locRegion = json['LocRegion'];
    oPStartdt = json['OP_startdt'];
    oPEnddt = json['OP_enddt'];
    computerised = json['Computerised'];
    dataentry = json['Dataentry'];
    locStartdt = json['loc_startdt'];
    locEnddt = json['loc_enddt'];
    paymentType = json['payment_type'];
    deliveryType = json['delivery_type'];
    uPDTBY = json['UPDTBY'];
    uPDTON = json['UPDTON'];
    dKTPFX = json['DKT_PFX'];
    modeSurface = json['Mode_Surface'];
    modeSea = json['Mode_Sea'];
    pickupDoor = json['Pickup_Door'];
    pickupGodown = json['Pickup_Godown'];
    billedAt = json['BilledAt'];
    vol = json['Vol'];
    cODDOD = json['COD_DOD'];
    oDA = json['ODA'];
    octroiArea = json['Octroi_Area'];
    dlyStartDt = json['Dly_StartDt'];
    dlyEndDt = json['Dly_EndDt'];
    transshipmentStartDt = json['Transshipment_StartDt'];
    transshipmentEndDt = json['Transshipment_EndDt'];
    cPC = json['CPC'];
    cnPrefixcode = json['cn_prefixcode'];
    oPUGD = json['OP_UGD'];
    locid = json['locid'];
    deliveryControlLoc = json['Delivery_Control_Loc'];
    barcodeScanAllowed = json['BarcodeScanAllowed'];
    isPeritNoReq = json['IsPeritNoReq'];
    isKeyNoReq = json['IsKeyNoReq'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    isVirtualLocation = json['IsVirtualLocation'];
    locNameLocCode = json['LocName_LocCode'];
    locAddrLat = json['LocAddrLat'];
    locAddrLng = json['LocAddrLng'];
    acccode = json['Acccode'];
    column1 = json['Column1'];
    accdesc = json['Accdesc'];
    locStartdtStr = json['loc_startdt_str'];
    locEnddtStr = json['loc_enddt_str'];
    city = json['City'];
    cityName = json['CityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Loc_Level'] = locLevel;
    data['Report_Level'] = reportLevel;
    data['LocCode'] = locCode;
    data['LocName'] = locName;
    data['Report_Loc'] = reportLoc;
    data['LocAddr'] = locAddr;
    data['LocState'] = locState;
    data['LocCity'] = locCity;
    data['LocPincode'] = locPincode;
    data['LocSTDCode'] = locSTDCode;
    data['LocTelno'] = locTelno;
    data['LocFaxno'] = locFaxno;
    data['Locmobile'] = locmobile;
    data['LocEmail'] = locEmail;
    data['Loc_Account'] = locAccount;
    data['ActiveFlag'] = activeFlag;
    data['Op_Bkg'] = opBkg;
    data['Op_Dly'] = opDly;
    data['Op_Tranship'] = opTranship;
    data['OutSource_Own'] = outSourceOwn;
    data['Octroi_IO'] = octroiIO;
    data['AirService'] = airService;
    data['RailService'] = railService;
    data['Default_NextLoc'] = defaultNextLoc;
    data['Nearest_PrevLoc'] = nearestPrevLoc;
    data['CutOff_YN'] = cutOffYN;
    data['Bkg_CutOffTime'] = bkgCutOffTime;
    data['DocketGen_Auto'] = docketGenAuto;
    data['LocAbbrev'] = locAbbrev;
    data['LocRegion'] = locRegion;
    data['OP_startdt'] = oPStartdt;
    data['OP_enddt'] = oPEnddt;
    data['Computerised'] = computerised;
    data['Dataentry'] = dataentry;
    data['loc_startdt'] = locStartdt;
    data['loc_enddt'] = locEnddt;
    data['payment_type'] = paymentType;
    data['delivery_type'] = deliveryType;
    data['UPDTBY'] = uPDTBY;
    data['UPDTON'] = uPDTON;
    data['DKT_PFX'] = dKTPFX;
    data['Mode_Surface'] = modeSurface;
    data['Mode_Sea'] = modeSea;
    data['Pickup_Door'] = pickupDoor;
    data['Pickup_Godown'] = pickupGodown;
    data['BilledAt'] = billedAt;
    data['Vol'] = vol;
    data['COD_DOD'] = cODDOD;
    data['ODA'] = oDA;
    data['Octroi_Area'] = octroiArea;
    data['Dly_StartDt'] = dlyStartDt;
    data['Dly_EndDt'] = dlyEndDt;
    data['Transshipment_StartDt'] = transshipmentStartDt;
    data['Transshipment_EndDt'] = transshipmentEndDt;
    data['CPC'] = cPC;
    data['cn_prefixcode'] = cnPrefixcode;
    data['OP_UGD'] = oPUGD;
    data['locid'] = locid;
    data['Delivery_Control_Loc'] = deliveryControlLoc;
    data['BarcodeScanAllowed'] = barcodeScanAllowed;
    data['IsPeritNoReq'] = isPeritNoReq;
    data['IsKeyNoReq'] = isKeyNoReq;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['IsVirtualLocation'] = isVirtualLocation;
    data['LocName_LocCode'] = locNameLocCode;
    data['LocAddrLat'] = locAddrLat;
    data['LocAddrLng'] = locAddrLng;
    data['Acccode'] = acccode;
    data['Column1'] = column1;
    data['Accdesc'] = accdesc;
    data['loc_startdt_str'] = locStartdtStr;
    data['loc_enddt_str'] = locEnddtStr;
    data['City'] = city;
    data['CityName'] = cityName;
    return data;
  }

  @override
  String toString() {
    if (locCode == null) {
      return '$acccode | $accdesc';
    } else {
      return locCode!;
    }
  }
}
