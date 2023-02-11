import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log Out",
    content: "Are you sure you want to log out",
    optionsBuilder: () => {
      "Cancel": false,
      "Log Out": true,
    },
  ).then(
    (value) => value ?? false,
  );
  /*final ret = await showGenericDialog<bool>(
    context: context,
    title: "Log Out",
    content: "Are you sure you want to log out",
    optionsBuilder: () => {
      "Cancel": false,
      "Log Out": true,
    },
  );
  if (ret == null) {
    return false;
  } else {
    return ret;
  } */
}
