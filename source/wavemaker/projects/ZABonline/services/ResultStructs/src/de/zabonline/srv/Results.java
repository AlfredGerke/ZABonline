package de.zabonline.srv;

public class Results extends com.wavemaker.runtime.javaservice.JavaServiceSuperClass {

    public Results() {
       super(INFO);
    }

    public static class SuccessInfo {
		Integer success;

		public void setSuccess(Integer success) {
			this.success = success;
		}

		public Integer getSuccess() {
			return this.success;
		}
	}

	public static class ProcResults {
		Integer success;
		Integer code;		
		String info;

		public void setSuccess(Integer success) {
			this.success = success;
		}

		public Integer getSuccess() {
			return this.success;
		}
		
		public void setCode(Integer code) {
			this.code = code;
		}

		public Integer getCode() {
			return this.code;
		}

		public void setInfo(String info) {
			this.info = info;
		}

		public String getInfo() {
			return this.info;
		}
	}
}
