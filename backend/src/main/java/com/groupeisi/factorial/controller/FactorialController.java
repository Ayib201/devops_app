package com.groupeisi.factorial.controller;

import com.groupeisi.factorial.model.FactorialRequest;
import com.groupeisi.factorial.service.FactorialService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class FactorialController {

    @GetMapping("/factorial")
    public ResponseEntity<Long> getFactorial(@RequestParam int number) {
        long result = factorial(number);
        return ResponseEntity.ok(result);
    }

    private long factorial(int number) {
        if (number == 0) return 1;
        return number * factorial(number - 1);
    }
}
