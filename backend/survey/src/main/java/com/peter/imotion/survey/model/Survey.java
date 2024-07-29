package com.peter.imotion.survey.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Survey {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private Long u_id;

    private String email;
    private String phone;
    private String age;
    private String selectedGender;
    private String selectedMaritalStatus;
    private String workingAddress;
    private String selectedEmployment;
    private String selectedWorkplace;
    private String totalMember;
    private String totalChildren;
    private String incomeRange;
    private String homeAddress;
}
