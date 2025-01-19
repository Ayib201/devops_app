package com.groupeisi.factorial;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import com.groupeisi.factorial.service.FactorialService;

import java.math.BigInteger;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class FactorialApplicationTests {

    private final FactorialService factorialService = new FactorialService();

    @Test
    void testCalculateFactorialPositive() {
        assertEquals(BigInteger.valueOf(120), factorialService.calculateFactorial(5));
    }

    @Test
    void testCalculateFactorialZero() {
        assertEquals(BigInteger.ONE, factorialService.calculateFactorial(0));
    }

    @Test
    void testCalculateFactorialNegative() {
        assertThrows(IllegalArgumentException.class, () -> factorialService.calculateFactorial(-1));
    }

    @Test
    void testCalculateFactorialLargeNumber() {
        BigInteger expected = new BigInteger("2432902008176640000"); // 20!
        assertEquals(expected, factorialService.calculateFactorial(20));
    }
}
