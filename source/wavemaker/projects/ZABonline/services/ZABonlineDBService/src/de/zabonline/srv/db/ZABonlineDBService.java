package de.zabonline.srv.db;

import com.wavemaker.runtime.RuntimeAccess;
import com.zabonlinedb.ZABonlineDB;

public class ZABonlineDBService extends com.wavemaker.runtime.javaservice.JavaServiceSuperClass {

    public ZABonlineDBService() {
       super(INFO);
    }

    public static ZABonlineDB getZABonlineDBService() {
		@SuppressWarnings("deprecation")		
		ZABonlineDB dbService = (ZABonlineDB) RuntimeAccess.getInstance()
				.getService(ZABonlineDB.class);
		return dbService;
	}
}
