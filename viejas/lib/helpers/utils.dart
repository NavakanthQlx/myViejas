import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showSnackBar(BuildContext context, String message,
      {String actionMessage = "", VoidCallback? onClick}) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: actionMessage,
        onPressed: () {
          if (onClick != null) {
            return onClick();
          }
        },
      ),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> showiOSDialog(BuildContext context,
      {String title = 'Alert',
      String message = 'message',
      String oktitle = 'Ok',
      String cancelTitle = 'Cancel',
      VoidCallback? okCallback,
      VoidCallback? cancelCallback}) async {
    showCupertinoDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: Text(oktitle),
                onPressed: () {
                  Navigator.pop(context);
                  if (okCallback != null) {
                    okCallback();
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text(cancelTitle),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (cancelCallback != null) {
                    cancelCallback();
                  }
                },
              ),
            ],
          );
        });
  }

  static Future<void> showAndroidDialog(BuildContext context,
      {String title = 'Alert',
      String message = 'message',
      String oktitle = 'Ok',
      String cancelTitle = 'Cancel',
      bool showCancelButton = true,
      VoidCallback? okCallback,
      VoidCallback? cancelCallback}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (cancelCallback != null) {
                  cancelCallback();
                }
              },
              child: Text(showCancelButton ? cancelTitle : ''),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (okCallback != null) {
                  okCallback();
                }
              },
              child: Text(oktitle),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showiOSActionSheet(BuildContext context,
      {String title = 'Alert',
      String message = 'message',
      String title1 = 'title1',
      String title2 = 'title2',
      String cancelTitle = 'Cancel',
      VoidCallback? title1Callback,
      VoidCallback? title2Callback,
      VoidCallback? cancelCallback}) async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) {
          return CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
            cancelButton: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (cancelCallback != null) {
                    cancelCallback();
                  }
                },
                child: Text(cancelTitle)),
            actions: [
              CupertinoActionSheetAction(
                child: Text(title1),
                onPressed: () {
                  Navigator.pop(context);
                  if (title1Callback != null) {
                    title1Callback();
                  }
                },
              ),
              CupertinoActionSheetAction(
                child: Text(title2),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (title2Callback != null) {
                    title2Callback();
                  }
                },
              ),
            ],
          );
        });
  }
}
