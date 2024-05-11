import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.yandex.mapkit.MapKitFactory;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    
    MapKitFactory.setApiKey("a46acb20-9d5a-4a5c-8323-e92119998634"); // Your generated API key
    super.configureFlutterEngine(flutterEngine);
  }
}