package de.zabonline.srv.db;

import com.wavemaker.runtime.javaservice.JavaServiceSuperClass;
import com.wavemaker.runtime.service.annotations.ExposeToClient;

@ExposeToClient
public class FactoryManagement extends JavaServiceSuperClass {

    public FactoryManagement() {
       super(INFO);
    }

}
