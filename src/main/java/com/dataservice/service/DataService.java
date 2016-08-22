package com.dataservice.service;

import com.dataservice.domain.Data;
import com.dataservice.repository.DataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

/* Service Class to access Repository */
@Service
public class DataService {

    @Autowired
    private DataRepository DataRepository;

    public DataService() {
    }

    public Data createData(Data data) {
        return DataRepository.save(data);
    }

    public Data getData(long id) {
        return DataRepository.findOne(id);
    }

    public void updateData(Data data) {
        DataRepository.save(data);
    }

    public void deleteData(Long id) {
        DataRepository.delete(id);
    }

    public Page<Data> getAllData(Integer page, Integer size) {
        Page pageOfData = DataRepository.findAll(new PageRequest(page, size));
        return pageOfData;
    }
}