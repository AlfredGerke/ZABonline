package de.zabonline.srv;

import com.wavemaker.runtime.javaservice.JavaServiceSuperClass;
import com.wavemaker.runtime.service.annotations.ExposeToClient;

@ExposeToClient
public class MiscAnonym extends JavaServiceSuperClass {

  public MiscAnonym() {

    super(INFO);
  }

  public void invalidateSession() {

    com.wavemaker.runtime.RuntimeAccess.getInstance()
        .getRequest()
        .getSession()
        .invalidate();
  }
}
