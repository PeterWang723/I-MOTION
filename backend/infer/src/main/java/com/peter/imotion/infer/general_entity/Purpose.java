package com.peter.imotion.infer.general_entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Purpose {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String purpose;
    private Double time;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "activity_id")
    @JsonIgnore
    private Activity activity;
}
