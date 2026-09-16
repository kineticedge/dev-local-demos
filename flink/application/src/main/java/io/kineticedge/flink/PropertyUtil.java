package io.kineticedge.flink;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class PropertyUtil {

    public static Properties toProperties(final Map<String, Object> map) {
        final Properties properties = new Properties();
        properties.putAll(map);
        return properties;
    }

    public static Map<String, ?> fromProperties(final Properties properties) {

        final Map<String, Object> map = new HashMap<>();

        if (properties == null) {
            return map;
        }

        properties.forEach((k, v) -> map.put((String) k, v));

        return map;
    }
}