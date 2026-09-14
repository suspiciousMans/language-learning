import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.*;
import org.mockito.*;
import org.mockito.junit.jupiter.*;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Real-World Test Case: Order Processing System")
class Exercise4_RealWorldTestCase {

    @Mock
    private PaymentGateway paymentGateway;

    @Mock
    private InventoryService inventoryService;

    @Mock
    private NotificationService notificationService;

    // Class under test
    private OrderProcessor orderProcessor;

    @BeforeEach
    void setUp() {
        orderProcessor = new OrderProcessor(paymentGateway, inventoryService, notificationService);
    }

    @Test
    @DisplayName("Successful order: payment OK, inventory available, notification sent")
    void testSuccessfulOrder() {
        // Arrange
        Order order = new Order(1, "Alice", List.of(
            new OrderItem("Laptop", 1, 999.99),
            new OrderItem("Mouse", 2, 29.99)
        ));
        double total = 999.99 + 2 * 29.99;  // 1059.97

        when(paymentGateway.charge(anyString(), anyDouble()))
            .thenReturn(true);
        when(inventoryService.reserveItems(anyList()))
            .thenReturn(true);
        when(notificationService.sendConfirmation(anyString(), anyString()))
            .thenReturn(true);

        // Act
        OrderResult result = orderProcessor.processOrder(order);

        // Assert
        assertTrue(result.success(), "Order should succeed");
        assertEquals("Order #1 processed successfully", result.message());
        assertEquals(1059.97, result.total(), 0.01);

        // Verify interactions
        verify(paymentGateway).charge("Alice", total);
        verify(inventoryService).reserveItems(order.items());
        verify(notificationService).sendConfirmation("Alice", "Order #1 confirmed");

        verifyNoMoreInteractions(paymentGateway);
        verifyNoMoreInteractions(inventoryService);
        verifyNoMoreInteractions(notificationService);
    }

    @Test
    @DisplayName("Failed payment: order should not be processed")
    void testFailedPayment() {
        // Arrange
        Order order = new Order(2, "Bob", List.of(
            new OrderItem("Keyboard", 1, 79.99)
        ));
        double total = 79.99;

        when(paymentGateway.charge(anyString(), anyDouble()))
            .thenReturn(false);

        // Act
        OrderResult result = orderProcessor.processOrder(order);

        // Assert
        assertFalse(result.success(), "Order should fail");
        assertTrue(result.message().contains("payment"), "Message should mention payment");
        assertEquals(0, result.total(), 0.01);

        // Inventory should NOT be touched
        verify(inventoryService, never()).reserveItems(anyList());
        verify(notificationService, never()).sendConfirmation(anyString(), anyString());
    }

    @Test
    @DisplayName("Inventory unavailable: payment should not be attempted")
    void testInventoryUnavailable() {
        // Arrange
        Order order = new Order(3, "Charlie", List.of(
            new OrderItem("Monitor", 1, 299.99)
        ));

        when(inventoryService.reserveItems(anyList()))
            .thenReturn(false);

        // Act
        OrderResult result = orderProcessor.processOrder(order);

        // Assert
        assertFalse(result.success());
        assertTrue(result.message().contains("inventory"));

        // Payment should NOT be attempted
        verify(paymentGateway, never()).charge(anyString(), anyDouble());
        verify(notificationService, never()).sendConfirmation(anyString(), anyString());
    }

    @Test
    @DisplayName("Empty order should be rejected")
    void testEmptyOrder() {
        Order emptyOrder = new Order(4, "Dave", List.of());

        OrderResult result = orderProcessor.processOrder(emptyOrder);

        assertFalse(result.success());
        assertTrue(result.message().contains("empty") || result.message().contains("no items"));
        verifyNoInteractions(paymentGateway);
        verifyNoInteractions(inventoryService);
        verifyNoInteractions(notificationService);
    }

    // Supporting classes
    record Order(int orderId, String customerName, List<OrderItem> items) {}
    record OrderItem(String product, int quantity, double unitPrice) {}
    record OrderResult(boolean success, String message, double total) {}

    interface PaymentGateway {
        boolean charge(String customerName, double amount);
    }

    interface InventoryService {
        boolean reserveItems(List<OrderItem> items);
    }

    interface NotificationService {
        boolean sendConfirmation(String customerName, String message);
    }

    static class OrderProcessor {
        private final PaymentGateway paymentGateway;
        private final InventoryService inventoryService;
        private final NotificationService notificationService;

        public OrderProcessor(PaymentGateway paymentGateway,
                             InventoryService inventoryService,
                             NotificationService notificationService) {
            this.paymentGateway = paymentGateway;
            this.inventoryService = inventoryService;
            this.notificationService = notificationService;
        }

        public OrderResult processOrder(Order order) {
            if (order.items().isEmpty()) {
                return new OrderResult(false, "Order is empty — no items to process", 0.0);
            }

            double total = order.items().stream()
                .mapToDouble(item -> item.unitPrice() * item.quantity())
                .sum();

            if (!paymentGateway.charge(order.customerName(), total)) {
                return new OrderResult(false, "Payment failed for order #" + order.orderId(), 0.0);
            }

            if (!inventoryService.reserveItems(order.items())) {
                return new OrderResult(false, "Inventory unavailable for order #" + order.orderId(), 0.0);
            }

            notificationService.sendConfirmation(order.customerName(),
                "Order #" + order.orderId() + " confirmed");

            return new OrderResult(true, "Order #" + order.orderId() + " processed successfully", total);
        }
    }
}
