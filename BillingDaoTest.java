package Daos;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.sql.SQLException;
import java.util.List;
import Models.Bill;

/**
 * JUnit 5 test for BillingDao.
 */
public class BillingDaoTest {

    private BillingDao billingDao;

    @BeforeEach
    void setUp() {
        billingDao = new BillingDao();
    }

    @Test
    @DisplayName("Test fetching all bills with details")
    void testGetAllBillsWithDetails() throws SQLException {
        List<Bill> bills = billingDao.getAllBillsWithDetails();
        assertNotNull(bills, "Bills list should not be null");
    }

    @Test
    @DisplayName("Test bill details consistency if bills exist")
    void testBillDetailsConsistency() throws SQLException {
        List<Bill> bills = billingDao.getAllBillsWithDetails();
        if (!bills.isEmpty()) {
            Bill firstBill = bills.get(0);
            assertTrue(firstBill.getResId() > 0, "Reservation ID should be positive");
            assertTrue(firstBill.getTotalPrice() >= 0, "Total price should be non-negative");
        }
    }
}
