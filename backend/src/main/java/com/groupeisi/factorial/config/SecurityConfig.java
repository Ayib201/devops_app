package com.groupeisi.factorial.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebSecurity
public class SecurityConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // Permet l'accès CORS depuis le domaine spécifique
        registry.addMapping("/api/**")
                .allowedOrigins("http://127.0.0.1:5501")  // Autorise les requêtes venant de ce domaine
                .allowedMethods("GET", "POST")  // Méthodes autorisées
                .allowedHeaders("*");  // Permet tous les en-têtes
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers("/api/**");  // Ignorer la sécurité pour l'API
    }





}
