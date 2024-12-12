class SalesManItemsBalance {
  String? cOMAPNYNO;
  String? sTOCKCODE;
  String? itemOCode;
  String? qTY;

  SalesManItemsBalance({
    this.cOMAPNYNO,
    this.sTOCKCODE,
    this.itemOCode,
    this.qTY,
  });

  factory SalesManItemsBalance.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesManItemsBalance(
      cOMAPNYNO: json['COMAPNYNO'],
      sTOCKCODE: json['STOCK_CODE'],
      itemOCode: json['ItemOCode'],
      qTY: json['QTY'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'COMAPNYNO': cOMAPNYNO,
      'STOCK_CODE': sTOCKCODE,
      'ItemOCode': itemOCode,
      'QTY': qTY,
    };
  }
}
