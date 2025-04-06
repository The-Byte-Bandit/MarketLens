import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorDisplay extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final IconData icon;
  final Color color;

  const ErrorDisplay({
    super.key,
    required this.error,
    required this.onRetry,
    this.icon = Icons.error_outline,
    this.color = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 20),
            Text(
              _getUserFriendlyMessage(error),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              onPressed: () {
                HapticFeedback.lightImpact();
                onRetry();
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              child: const Text('Copy Error Details'),
              onPressed: () => _copyErrorDetails(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserFriendlyMessage(String error) {
    if (error.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    } else if (error.contains('404')) {
      return 'Content not found. Please try again later.';
    } else if (error.contains('Timeout')) {
      return 'Request timed out. Please check your connection.';
    }
    return 'Oops! Something went wrong. Please try again.';
  }

  void _copyErrorDetails(BuildContext context) {
    Clipboard.setData(ClipboardData(text: error));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error details copied to clipboard')),
    );
  }
}
