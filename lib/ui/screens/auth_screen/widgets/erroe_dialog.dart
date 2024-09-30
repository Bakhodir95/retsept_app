
import 'package:flutter/material.dart';
import 'package:retsept_app/ui/screens/auth_screen/screens/login_screen.dart';

class BeautifulErrorDialog extends StatelessWidget {
  final ErrorType errorType;
  final String message;

  const BeautifulErrorDialog({
    super.key,
    required this.errorType,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    IconData icon;
    Color color;

    switch (errorType) {
      case ErrorType.network:
        title = "Tarmoq xatosi";
        icon = Icons.wifi_off;
        color = Colors.orange;
        break;
      case ErrorType.authentication:
        title = "Bunday email mavjud";
        icon = Icons.lock;
        color = Colors.red;
        break;
      case ErrorType.validation:
        title = "Noto'g'ri ma'lumot";
        icon = Icons.error_outline;
        color = Colors.yellow[700]!;
        break;
      case ErrorType.unknown:
      default:
        title = "Xatolik yuz berdi";
        icon = Icons.error;
        color = Colors.red;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: color,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3FB4B1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
