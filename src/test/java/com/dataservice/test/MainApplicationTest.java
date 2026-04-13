package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = DataServiceSpringController.class)
public class MainApplicationTest {

    @Test
    public void main() {
        DataServiceSpringController.main(new String[] {});
    }
}
