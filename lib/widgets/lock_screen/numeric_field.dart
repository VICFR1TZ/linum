import 'package:flutter/material.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:provider/provider.dart';

class NumericField extends StatelessWidget {
  final int value;
  final Function? onPress;

  const NumericField(this.value, this.onPress);

  @override
  Widget build(BuildContext context) {
    PinCodeProvider pinCodeProvider = Provider.of<PinCodeProvider>(context);

    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: TextButton(
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.headline3,
          ),
          onPressed: () {
            pinCodeProvider.addDigit(value);
          },
          style: TextButton.styleFrom(
            shape: CircleBorder(),
          ),
        ),
      ),
    );
  }
}
