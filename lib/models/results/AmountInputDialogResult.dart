import 'package:financemanager/models/Account.dart';

class AmountInputDialogResult {
  final int currentAmount;
  final bool addPressed;
  final Account? account;

  AmountInputDialogResult(this.currentAmount, this.addPressed, this.account);
}
