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

    // Creates a data object and persist to database
    public Data createData(Data data) {
        return DataRepository.save(data);
    }

    // Get matching data object that matches id and returns to user.
    public Data getData(long id) {
        return DataRepository.findOne(id);
    }

    // Find and update data object
    public void updateData(Data data) {
        DataRepository.save(data);
    }

    //Find and delete data object
    public void deleteData(Long id) {
        DataRepository.delete(id);
    }

    // Get all data objects that match id and returns to user.
    public Page<Data> getAllData(Integer page, Integer size) {
        Page pageOfData = DataRepository.findAll(new PageRequest(page, size));
        return pageOfData;
    }
}