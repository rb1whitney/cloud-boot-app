package com.dataservice.test;

import com.dataservice.DataServiceSpringController;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest(classes = DataServiceSpringController.class)
@TestPropertySource(properties = {"management.endpoints.web.exposure.include=", "spring.test.mockmvc.print=true"})
public class MainApplicationTest {

    @Test
    public void main() {
        DataServiceSpringController.main(new String[] {});
    }
}
