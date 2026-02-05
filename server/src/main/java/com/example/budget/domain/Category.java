package com.example.budget.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter
@NoArgsConstructor
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name; // 식비, 교통비, 월급 ...

    private String icon; // 🍔, 🚌 ...

    public Category(String name, String icon) {
        this.name = name;
        this.icon = icon;
    }
}
