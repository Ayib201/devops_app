package com.groupeisi.factorial;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import com.groupeisi.factorial.service.FactorialService;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;


@SpringBootTest
class FactorialApplicationTests {


    private final FactorialService factorialService = new FactorialService();

    @Test
    void testCalculateFactorialPositive() {
        assertEquals(120, factorialService.calculateFactorial(5));
    }

    @Test
    void testCalculateFactorialZero() {
        assertEquals(1, factorialService.calculateFactorial(0));
    }

    @Test
    void testCalculateFactorialNegative() {
        assertThrows(IllegalArgumentException.class, () -> factorialService.calculateFactorial(-1));
    }

}
