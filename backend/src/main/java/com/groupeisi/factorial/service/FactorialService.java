package com.groupeisi.factorial.service;

import org.springframework.stereotype.Service;

@Service
public class FactorialService {
    public long calculateFactorial(int number) {
        if (number == 0 || number == 1) {
            return 1;
        }
        return number * calculateFactorial(number - 1);
    }
}
