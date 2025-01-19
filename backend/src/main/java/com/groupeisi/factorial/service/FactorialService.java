package com.groupeisi.factorial.service;

import org.springframework.stereotype.Service;

import java.math.BigInteger;

@Service
public class FactorialService {

    public BigInteger calculateFactorial(int number) {
        if (number < 0) {
            throw new IllegalArgumentException("Factorial is not defined for negative numbers.");
        }

        BigInteger result = BigInteger.ONE;
        for (int i = 2; i <= number; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }
}
