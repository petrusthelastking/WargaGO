import 'package:firebase_core/firebase_core.dart';
import 'create_admin.dart';
import 'firebase_options.dart';
void main() async {
  print('🚀 Initializing Firebase...\n');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase initialized!\n');
  // Buat admin2@jawara.com
  await createAdmin2();
  print('✅ Selesai!');
}
