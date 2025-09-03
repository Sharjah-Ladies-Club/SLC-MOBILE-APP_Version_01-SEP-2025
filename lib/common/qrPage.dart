import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:slc/view/Retail/Retail_Page.dart';

// ignore: must_be_immutable
class QrPage extends StatefulWidget {
  final Function(String scanCode) handlerCallback;
  String sourcePage =
      "RETAIL"; // callback that will give a handler object to change widget state.
  String colorCode;
  QrPage({this.handlerCallback, this.colorCode, this.sourcePage});

  @override
  _QrPageState createState() => _QrPageState(
      colorCode: colorCode,
      sourcePage: sourcePage,
      handlerCallback: handlerCallback);
}

class _QrPageState extends State<QrPage> {
  final Function(String scanCode) handlerCallback;
  String
      sourcePage; // callback that will give a handler object to change widget state.
  Barcode result;
  QRViewController controller;
  String colorCode;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  _QrPageState({this.handlerCallback, this.colorCode, this.sourcePage});

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller.resumeCamera();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Container(
          child: _buildQrView(context),
        ));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // setState(() {
    this.controller = controller;
    controller.resumeCamera();
    // });
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.pauseCamera();
      debugPrint("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD" + scanData.toString());
      // handlerCallback(scanData.code);
      String scanCode = "";
      if (scanData.code != null) {
        scanCode = scanData.code;
      }
      if (scanCode != null && scanCode != "") {
        if (widget.sourcePage == "FITNESS") {
          Navigator.pop(context);
          debugPrint("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDsssss" +
              scanCode +
              handlerCallback.toString());
          String scannedValue = scanData.code;
          handlerCallback(scannedValue);
        } else {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RetailPage(
                      facilityId: 0,
                      retailItemSetId: scanCode,
                      facilityItems: [],
                      colorCode: widget.colorCode,
                    )),
          );
        }
      } else {
        controller.resumeCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
