import 'package:flutter/material.dart';

showError(BuildContext context, String err) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(err),
      )
  );
}
