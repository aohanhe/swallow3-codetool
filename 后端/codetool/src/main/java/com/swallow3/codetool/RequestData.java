package com.swallow3.codetool;

import lombok.Data;
import swallow.framework.entitydescript.EntityDescript;


public class RequestData {
	private EntityDescript entityinfo;
	private String packagePath;
	
	public EntityDescript getEntityinfo() {
		return entityinfo;
	}
	public void setEntityinfo(EntityDescript entityinfo) {
		this.entityinfo = entityinfo;
	}
	public String getPackagePath() {
		return packagePath;
	}
	public void setPackagePath(String packagePath) {
		this.packagePath = packagePath;
	}

}
