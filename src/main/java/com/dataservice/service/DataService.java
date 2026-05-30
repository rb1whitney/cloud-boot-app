package com.dataservice.service;

import com.dataservice.domain.Data;
import com.dataservice.dto.DataDTO;
import com.dataservice.repository.DataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

/* Service Class to access Repository */
@Service
public class DataService {

    @Autowired
    private DataRepository dataRepository;

    public DataService() {
    }

    // Creates a data object and persist to database
    public DataDTO createData(DataDTO dataDTO) {
        Data data = convertToEntity(dataDTO);
        Data savedData = dataRepository.save(data);
        return convertToDTO(savedData);
    }

    // Get matching data object that matches id and returns to user.
    public DataDTO getData(long id) {
        return dataRepository.findById(id).map(this::convertToDTO).orElse(null);
    }

    // Find and update data object
    public void updateData(DataDTO dataDTO) {
        dataRepository.save(convertToEntity(dataDTO));
    }

    //Find and delete data object
    public void deleteData(Long id) {
        dataRepository.deleteById(id);
    }

    // Get all data objects that match id and returns to user.
    public Page<DataDTO> getAllData(Integer page, Integer size) {
        return dataRepository.findAll(PageRequest.of(page, size)).map(this::convertToDTO);
    }

    // Search data based on condition and values
    public Page<DataDTO> searchData(com.dataservice.validator.RangeCondition condition, java.util.List<String> values, Integer page, Integer size) {
        // Skeleton implementation returning an empty page or delegating to repository if applicable
        // For now, we return empty page as requested "at least a skeleton implementation"
        return Page.empty(PageRequest.of(page, size));
    }

    private DataDTO convertToDTO(Data data) {
        return new DataDTO(data.getId(), data.getName(), data.getDescription());
    }

    private Data convertToEntity(DataDTO dto) {
        return new Data(dto.getId(), dto.getName(), dto.getDescription());
    }
}