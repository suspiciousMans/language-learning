import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.*;
import org.mockito.*;
import org.mockito.junit.jupiter.*;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.*;

// Enable Mockito extension
@ExtendWith(MockitoExtension.class)
@DisplayName("Mockito Basics")
class Exercise3_MockitoBasics {

    // @Mock — creates a mock instance
    @Mock
    private List<String> mockList;

    // @Spy — wraps a real object, can stub specific methods
    @Spy
    private List<String> spyList = new ArrayList<>();

    @Test
    @DisplayName("1. Basic mock — stubbing and verification")
    void testBasicMock() {
        // Stub the mock
        when(mockList.get(0)).thenReturn("first");
        when(mockList.size()).thenReturn(3);

        // Use the mock
        String first = mockList.get(0);
        int size = mockList.size();

        // Verify
        assertEquals("first", first);
        assertEquals(3, size);
        verify(mockList).get(0);
        verify(mockList).size();
    }

    @Test
    @DisplayName("2. Mock returns default values for unstubbed methods")
    void testDefaultValues() {
        // Unstubbed get() returns null
        Object result = mockList.get(5);
        assertNull(result, "Unstubbed get returns null");

        // Unstubbed isEmpty returns false (default for boolean)
        assertFalse(mockList.isEmpty(), "Unstubbed isEmpty returns false");
    }

    @Test
    @DisplayName("3. Multiple stubbing with different arguments")
    void testMultipleStubbing() {
        when(mockList.get(0)).thenReturn("first");
        when(mockList.get(1)).thenReturn("second");
        when(mockList.get(2)).thenReturn("third");
        when(mockList.get(3)).thenReturn("fourth");  // default for out-of-range

        assertEquals("first", mockList.get(0));
        assertEquals("second", mockList.get(1));
        assertEquals("third", mockList.get(2));
        assertEquals("fourth", mockList.get(3), "Should return last stub for out-of-range");

        // Verify all interactions
        verify(mockList, times(4)).get(anyInt());
    }

    @Test
    @DisplayName("4. Spy — real object with partial mocking")
    void testSpy() {
        spyList.add("real1");
        spyList.add("real2");

        // Real methods work
        assertEquals(2, spyList.size());

        // Stub specific methods
        when(spyList.size()).thenReturn(100);

        // Stubbed takes precedence
        assertEquals(100, spyList.size());

        // Clear the stub
        clearInvocations(spyList);
        reset(spyList);

        // Now real behavior again
        spyList.add("test");
        assertEquals(1, spyList.size());
    }

    @Test
    @DisplayName("5. Verification with count and order")
    void testVerification() {
        when(mockList.get(0)).thenReturn("a");
        when(mockList.get(1)).thenReturn("b");

        mockList.get(0);
        mockList.get(1);
        mockList.get(0);
        mockList.add("item");

        // Verify exact count
        verify(mockList, times(2)).get(0);
        verify(mockList, times(1)).get(1);
        verify(mockList, times(1)).add("item");

        // Verify never called
        verify(mockList, never()).clear();
        verify(mockList, never()).remove("something");

        // Verify at least / at most
        verify(mockList, atLeastOnce()).get(anyInt());
    }

    @Test
    @DisplayName("6. Argument matchers")
    void testArgumentMatchers() {
        when(mockList.contains(anyString())).thenReturn(true);
        when(mockList.get(anyInt())).thenReturn("matched");

        assertTrue(mockList.contains("anything"));
        assertTrue(mockList.contains("whatever"));
        assertEquals("matched", mockList.get(999));

        // Verify with matcher
        verify(mockList).contains(anyString());
        verify(mockList, atLeastOnce()).get(anyInt());

        // Note: cannot mix matchers and raw values
        // when(mockList.get(0)).thenReturn("x");  // This is fine — no matcher
        // when(mockList.contains("test")).thenReturn(false);  // Also fine
    }

    @Test
    @DisplayName("7. doThrow / doAnswer — stubbing void methods and exceptions")
    void testDoThrow() {
        doThrow(new RuntimeException("boom!"))
            .doReturn("ok")
            .when(mockList).add("error");

        assertThrows(RuntimeException.class, () -> mockList.add("error"),
            "Should throw RuntimeException");

        String result = mockList.add("ok");
        assertEquals("ok", result);
    }

    @Test
    @DisplayName("8. doAnswer — dynamic responses based on arguments")
    void testDoAnswer() {
        doAnswer(invocation -> {
            String arg = invocation.getArgument(0);
            return "Got: " + arg.toUpperCase();
        }).when(mockList).add(anyString());

        String result = mockList.add("hello");
        assertEquals("Got: HELLO", result);
    }

    @Test
    @DisplayName("9. ArgumentCaptor — capture arguments passed to mocks")
    void testArgumentCaptor() {
        ArgumentCaptor<String> captor = ArgumentCaptor.forClass(String.class);

        mockList.add("first");
        mockList.add("second");
        mockList.add("third");

        verify(mockList, times(3)).add(captor.capture());

        List<String> captured = captor.getAllValues();
        assertEquals(3, captured.size());
        assertEquals("first", captured.get(0));
        assertEquals("second", captured.get(1));
        assertEquals("third", captured.get(2));
    }

    @Test
    @DisplayName("10. Mocking with @InjectMocks")
    void testInjectMocks() {
        // Create a service with a dependency
        EmailService service = new EmailService();

        // Mock the dependency
        EmailRepository mockRepo = mock(EmailRepository.class);

        // Inject mock into service
        service.repository = mockRepo;

        // Stub repository
        when(mockRepo.findByEmail("alice@example.com"))
            .thenReturn(new User(1, "Alice", "alice@example.com"));

        // Call service method
        User user = service.findUserByEmail("alice@example.com");

        // Verify
        assertNotNull(user);
        assertEquals("Alice", user.name());
        verify(mockRepo).findByEmail("alice@example.com");
    }

    // Simple classes for testing
    record User(int id, String name, String email) {}

    interface EmailRepository {
        User findByEmail(String email);
    }

    static class EmailService {
        EmailRepository repository;

        User findUserByEmail(String email) {
            return repository.findByEmail(email);
        }
    }
}
