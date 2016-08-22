package com.dataservice.repository;

import com.dataservice.domain.Data;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;

/* Repository Interface */

public interface DataRepository extends PagingAndSortingRepository<Data, Long> {
    Page findAll(Pageable pageable);
}
