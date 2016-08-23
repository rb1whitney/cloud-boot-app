package com.dataservice.repository;

import com.dataservice.domain.Data;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;

/* Repository Interface that is using Spring Boot Paging Repository*/

public interface DataRepository extends PagingAndSortingRepository<Data, Long> {
    // Will find all values and return them in Spring Boot Page
    Page findAll(Pageable pageable);
}
