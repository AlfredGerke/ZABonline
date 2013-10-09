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

/**
 * spezielle Typen der ZABonline
 * 
 * @author Alfred
 * 
 * @version 1.0.0 Build 1
 * 
 */
public class ZABonlineTypes {

  /*----------------------------------------------------------------------------------------*/
  /**
   * Mimetypes Idents
   * 
   * @author Alfred
   * 
   * @version 1.0.0 Build 1
   * 
   */
  public static class MimeTypeIdentInfo {

    Boolean found = false;
    String ident = "";

    /*----------------------------------------------------------------------------------------*/
    /**
		 * 
		 */
    public MimeTypeIdentInfo() {

      super();
    }

    /*----------------------------------------------------------------------------------------*/
    /*
		 * 
		 */
    private void setFound(Boolean aFound) {

      this.found = aFound;
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @return
     */
    public Boolean getFound() {

      return this.found;
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @param aIdent
     */
    public void setIdent(String aIdent) {

      this.ident = aIdent;
      setFound(!this.ident.trim()
          .isEmpty());
    }

    /*----------------------------------------------------------------------------------------*/
    /**
     * 
     * @return
     */
    public String getIdent() {

      return this.ident;
    }
  }
}
