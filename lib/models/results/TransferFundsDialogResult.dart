import '../Account.dart';

class TransferFundsDialogResult {
  final Account? selectedAccountFrom;
  final Account? selectedAccountTo;
  final double amountToTransfer;

  TransferFundsDialogResult(
      {required this.selectedAccountFrom,
      required this.selectedAccountTo,
      required this.amountToTransfer});
}
