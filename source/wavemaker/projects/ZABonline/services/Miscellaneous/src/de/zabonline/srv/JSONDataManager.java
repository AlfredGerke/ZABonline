/**
 *  Erweiterung der von Wavemaker erstellten Javasourcen
 * 
 *  1.0.0 Build 1
 *  
 *  2013-03-26
 *  
 *  Copyright by Alfred Gerke
 */
package de.zabonline.srv;

import org.json.JSONException;
import org.json.JSONObject;

import de.zabonline.srv.Results;
import de.zabonline.srv.ZABonlineConstants;

/**
 * Händling der JSON-Strings aus der Datenbank für ZABonline
 * 
 * @author Alfred
 * 
 * @version 1.0.0 Build 1
 * 
 */
public class JSONDataManager {

  private static JSONDataManager jdm;

  /*----------------------------------------------------------------------------------------*/
  /**
	 * 
	 */
  private JSONDataManager() {

    super();
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @return
   */
  public static JSONDataManager getInstance() {

    if (jdm == null) {
      jdm = new JSONDataManager();
    }

    return jdm;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aRes
   * @param aKey
   * @return
   */
  public Integer getIntegerByIdent(Results.ProcResults aRes,
    String aKey) {

    Integer result = ZABonlineConstants.INIT_DEFAULT_INT_BY_JSON;

    if (aRes.getCode() == 1) {
      result = getIntegerByIdent(aRes.getInfo(),
        aKey);
    }

    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aJSONString
   * @param aKey
   * @return
   */
  public Integer getIntegerByIdent(String aJSONString,
    String aKey) {

    Integer result = ZABonlineConstants.INIT_DEFAULT_INT_BY_JSON;
    String errorMsg = "";

    if (!aJSONString.trim()
        .isEmpty()) {
      try {
        JSONObject json = new JSONObject(aJSONString);
        result = json.getInt(aKey);
      } catch (JSONException ex) {
        result = ZABonlineConstants.INIT_DEFAULT_INT_BY_JSON;

        if (ex.getCause() == null) {
          errorMsg = ex.getMessage();
        } else {
          errorMsg = ex.getCause()
              .getMessage();
        }

        if (errorMsg.trim()
            .isEmpty()) {
          errorMsg = ZABonlineConstants.ERROR_GET_INT_BY_JSON_FAILD;
        }

        throw new RuntimeException(errorMsg);
      }
    }
    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aJSONString
   * @param aKey
   * @return
   */
  public String getStringByIdent(String aJSONString,
    String aKey) {

    String result = "";
    String errorMsg = "";

    if (!aJSONString.trim()
        .isEmpty()) {
      try {
        JSONObject json = new JSONObject(aJSONString);
        result = json.getString(aKey);
      } catch (JSONException ex) {
        result = "";

        if (ex.getCause() == null) {
          errorMsg = ex.getMessage();
        } else {
          errorMsg = ex.getCause()
              .getMessage();
        }

        if (errorMsg.trim()
            .isEmpty()) {
          errorMsg = ZABonlineConstants.ERROR_GET_STRING_BY_JSON_FAILD;
        }

        throw new RuntimeException(errorMsg);
      }
    }
    return result;
  }

  /*----------------------------------------------------------------------------------------*/
  /**
   * 
   * @param aRes
   * @param aKey
   * @return
   */
  public String getStringByIdent(Results.ProcResults aRes,
    String aKey) {

    String result = "";

    if (aRes.getCode() == 1) {
      result = getStringByIdent(aRes.getInfo(),
        aKey);
    }

    return result;
  }
}
