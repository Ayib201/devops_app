package com.groupeisi.factorial.controller;

import com.groupeisi.factorial.service.FactorialService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigInteger;

@RestController
@RequestMapping("/api")
public class FactorialController {

    private final FactorialService factorialService;

    @Autowired
    public FactorialController(FactorialService factorialService) {
        this.factorialService = factorialService;
    }

    @GetMapping("/factorial")
    public ResponseEntity<BigInteger> getFactorial(@RequestParam int number) {
        BigInteger result = factorialService.calculateFactorial(number);
        return ResponseEntity.ok(result);
    }
}
