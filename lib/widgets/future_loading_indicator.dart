import 'package:doctor_mfc/widgets/loading_indicator_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds an undismissible Loading Indicator Alert Dialog that stays until the
/// future has completed with or without an error.
///
/// The `future` parameter is the future that will be executed.
///
/// The optional `timeoutAt` parameter is the time that the future will have to
/// complete before an onTimeoutError is thrown.
Future<T?> futureLoadingIndicator<T>(
  BuildContext context,
  Future<T> future, {
  Duration? timeoutAt,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      // future.then<T?>((result) {
      future.then<T?>((result) {
        // If the future completes successfully, dismiss the dialog.
        Navigator.pop(context, result);
      }, onError: (error, stackTrace) {
        // If the future completes with an error, dismiss the loading dialog
        // and show the error dialog.
        Navigator.pop(context);

        _onErrorDialog(
          context: context,
          errorMessage: 'An unexpected error has ocurred: $error',
          onTryAgainFuture: future,
          error: error,
          stackTrace: stackTrace,
        );
      }).timeout(timeoutAt ?? Duration(seconds: 15), onTimeout: () {
        // If the future times out, dismiss the loading dialog
        // and show the error dialog with a Request Timeout message.
        Navigator.pop(context);
        _onErrorDialog(
          context: context,
          errorMessage: 'Request timeout',
          onTryAgainFuture: future,
        );
      });
      return LoadingIndicatorContainer();
    },
  );
}

/// The error dialog that is shown when an error occurs. It can be dismissed.
///
/// The 'onErrorMessage' parameter is the error message that is shown to the
/// user when this dialog is shown.
///
/// The `onTryAgainFuture` parameter is the future that will be executed when
/// the user taps the "Try Again" button.
///
/// The `error` parameter is the error that was thrown.
/// The `stackTrace` parameter is the stack trace of the error that was thrown.
/// Both the `error` and `stackTrace` parameters are for debugging purpose.
Future _onErrorDialog({
  required BuildContext context,
  String? errorMessage,
  Future? onTryAgainFuture,
  Object? error,
  StackTrace? stackTrace,
}) {
  print(error);
  print(stackTrace);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage ?? 'An error has ocurred'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          (onTryAgainFuture != null)
              ? TextButton(
                  child: Text('Try again'),
                  onPressed: () {
                    Navigator.pop(context);
                    futureLoadingIndicator(context, onTryAgainFuture);
                  })
              : Container(),
        ],
      );
    },
  );
}
