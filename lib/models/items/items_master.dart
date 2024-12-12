class ItemsMaster {
  String? cOMAPNYNO;
  String? iTEMNO;
  String? nAME;
  String? cATEOGRYID;
  String? itemK;
  String? bARCODE;
  String? mINPRICE;
  String? iTEML;
  String? iSSUSPENDED;
  String? fD;
  String? iTEMHASSERIAL;
  String? iTEMPICSPATH;
  String? tAXPERC;
  String? iSAPIPIC;
  String? lSPRICE;

  ItemsMaster({
    this.cOMAPNYNO,
    this.iTEMNO,
    this.nAME,
    this.cATEOGRYID,
    this.itemK,
    this.bARCODE,
    this.mINPRICE,
    this.iTEML,
    this.iSSUSPENDED,
    this.fD,
    this.iTEMHASSERIAL,
    this.iTEMPICSPATH,
    this.tAXPERC,
    this.iSAPIPIC,
    this.lSPRICE,
  });

  factory ItemsMaster.fromJson(Map<String, dynamic> json) {
    return ItemsMaster(
      cOMAPNYNO: json['COMAPNYNO'],
      iTEMNO: json['ITEMNO'],
      nAME: json['NAME'],
      cATEOGRYID: json['CATEOGRYID'],
      itemK: json['ItemK'],
      bARCODE: json['BARCODE'],
      mINPRICE: json['MINPRICE'],
      iTEML: json['ITEML'],
      iSSUSPENDED: json['ISSUSPENDED'],
      fD: json['F_D'],
      iTEMHASSERIAL: json['ITEMHASSERIAL'],
      iTEMPICSPATH: json['ITEMPICSPATH'],
      tAXPERC: json['TAXPERC'],
      iSAPIPIC: json['ISAPIPIC'],
      lSPRICE: json['LSPRICE'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'COMAPNYNO': cOMAPNYNO,
      'ITEMNO': iTEMNO,
      'NAME': nAME,
      'CATEOGRYID': cATEOGRYID,
      'ItemK': itemK,
      'BARCODE': bARCODE,
      'MINPRICE': mINPRICE,
      'ITEML': iTEML,
      'ISSUSPENDED': iSSUSPENDED,
      'F_D': fD,
      'ITEMHASSERIAL': iTEMHASSERIAL,
      'ITEMPICSPATH': iTEMPICSPATH,
      'TAXPERC': tAXPERC,
      'ISAPIPIC': iSAPIPIC,
      'LSPRICE': lSPRICE,
    };
  }
}
