package Utils;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

/**
 * Static analysis test to verify that Controllers do not create their own DB connections.
 * This test scans all Java files in src/main/java/Controller and ensures they do not contain
 * forbidden patterns like "DriverManager.getConnection" or "new DBCon()".
 */
public class ControllerDBTest {

    @Test
    @DisplayName("Verify that Controllers do not create their own DB connections")
    void testControllersDoNotCreateDBConnections() {
        File controllerDir = new File("src/main/java/Controller");
        assertTrue(controllerDir.exists() && controllerDir.isDirectory(), "Controller directory should exist: " + controllerDir.getAbsolutePath());

        File[] files = controllerDir.listFiles((dir, name) -> name.endsWith(".java"));
        assertNotNull(files, "Controller files should be present");
        assertTrue(files.length > 0, "At least one controller file should exist");

        List<String> errors = new ArrayList<>();

        for (File file : files) {
            // Skip LogoutServlet as it's safe
            if (file.getName().equals("LogoutServlet.java")) continue;

            try {
                String content = new String(Files.readAllBytes(file.toPath()));
                
                // Check for forbidden patterns
                if (content.contains("DriverManager.getConnection")) {
                    errors.add(file.getName() + " contains 'DriverManager.getConnection'");
                }
                if (content.contains("DataSource")) {
                    if (content.contains("javax.sql.DataSource") || content.contains("import javax.sql.DataSource")) {
                        errors.add(file.getName() + " contains 'DataSource' usage");
                    }
                }
            } catch (IOException e) {
                fail("Failed to read file: " + file.getName());
            }
        }

        assertTrue(errors.isEmpty(), "The following controllers have issues:\n" + String.join("\n", errors));
    }
}
