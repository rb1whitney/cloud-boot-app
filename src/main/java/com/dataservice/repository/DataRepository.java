package com.dataservice.repository;

import com.dataservice.domain.Data;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

/* Repository Interface that is using Spring Boot Paging Repository*/

public interface DataRepository extends JpaRepository<Data, Long> {
    // Will find all values and return them in Spring Boot Page
    Page<Data> findAll(Pageable pageable);
}
