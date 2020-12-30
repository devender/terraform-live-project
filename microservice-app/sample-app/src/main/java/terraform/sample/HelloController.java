package terraform.sample;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping(path = "/time")
@Slf4j
@CrossOrigin
public class HelloController {

    @GetMapping
    public String getSymbols() {
        return "Time In Milli:" + System.currentTimeMillis();
    }
}
