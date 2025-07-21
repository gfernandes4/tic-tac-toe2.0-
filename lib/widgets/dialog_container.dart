import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import '../theme.dart';
import 'cell_widget.dart';

class DialogContainer extends StatelessWidget {
  final int mainRow;
  final int mainCol;
  final VoidCallback onClose;

  const DialogContainer({
    super.key,
    required this.mainRow,
    required this.mainCol,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Matriz ${mainRow + 1}x${mainCol + 1}',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.7, // Limita a altura
                      child: CellWidget(mainRow: mainRow, mainCol: mainCol),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Fechar',
                      onPressed: onClose,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: AppTheme.animationDuration).scale();
  }
}