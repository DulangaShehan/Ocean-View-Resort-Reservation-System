package Daos;

import org.junit.platform.suite.api.SelectPackages;
import org.junit.platform.suite.api.Suite;
import org.junit.platform.suite.api.SuiteDisplayName;
import org.junit.platform.launcher.Launcher;
import org.junit.platform.launcher.LauncherDiscoveryRequest;
import org.junit.platform.launcher.core.LauncherDiscoveryRequestBuilder;
import org.junit.platform.launcher.core.LauncherFactory;
import org.junit.platform.launcher.listeners.SummaryGeneratingListener;
import org.junit.platform.launcher.listeners.TestExecutionSummary;
import static org.junit.platform.engine.discovery.DiscoverySelectors.selectPackage;

/**
 * Explicit Test Suite for Ocean View Hotel.
 * This acts as the "Test Plan" for the IDE's JUnit runner.
 * 
 * FALLBACK: If JUnit view shows 0 tests, run this class as "Java Application"
 * and check the Console for results.
 */
@Suite
@SuiteDisplayName("Ocean View Hotel - Full Test Plan")
@SelectPackages({
    "Daos",
    "Utils"
})
public class FullTestPlan {

    public static void main(String[] args) {
        System.out.println("--- Starting Manual JUnit 5 Execution ---");
        
        LauncherDiscoveryRequest request = LauncherDiscoveryRequestBuilder.request()
            .selectors(
                selectPackage("Daos"),
                selectPackage("Utils")
            )
            .build();

        Launcher launcher = LauncherFactory.create();
        SummaryGeneratingListener listener = new SummaryGeneratingListener();
        launcher.registerTestExecutionListeners(listener);
        launcher.execute(request);

        TestExecutionSummary summary = listener.getSummary();
        System.out.println("\n--- TEST EXECUTION SUMMARY ---");
        System.out.println("Tests Found: " + summary.getTestsFoundCount());
        System.out.println("Tests Succeeded: " + summary.getTestsSucceededCount());
        System.out.println("Tests Failed: " + summary.getTestsFailedCount());
        System.out.println("------------------------------\n");
        
        if (summary.getTestsFailedCount() > 0) {
            summary.getFailures().forEach(failure -> {
                System.err.println("Failure in " + failure.getTestIdentifier().getDisplayName());
                failure.getException().printStackTrace();
            });
            System.exit(1);
        }
    }
}
