/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package info.papyri.dispatch;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import junit.framework.TestCase;

/**
 *
 * @author hcayless
 */
public class FileUtilsTest extends TestCase {
    
    public FileUtilsTest(String testName) {
        super(testName);
    }

    @Override
    protected void setUp() throws Exception {
        super.setUp();
    }

    @Override
    protected void tearDown() throws Exception {
        super.tearDown();
    }

  /**
   * Test of getHtmlFile method, of class FileUtils.
   */
  public void testGetHtmlFile() {
    System.out.println("getHtmlFile");
    String collection = "ddbdp";
    String item = "bgu;1;2";
    FileUtils instance = new FileUtils("/data/papyri.info/idp.data", "/data/papyri.info/pn/idp.html");
    File expResult = new File("/data/papyri.info/pn/idp.html/DDB_EpiDoc_XML/bgu/bgu.1/bgu.1.2.html");
    File result = instance.getHtmlFile(collection, item);
    assertEquals(expResult, result);
  }

  /**
   * Test of getTextFile method, of class FileUtils.
   */
  public void testGetTextFile() {
    System.out.println("getTextFile");
    String collection = "ddbdp";
    String item = "bgu;1;2";
    FileUtils instance = new FileUtils("/data/papyri.info/idp.data", "/data/papyri.info/pn/idp.html");
    File expResult = new File("/data/papyri.info/pn/idp.html/DDB_EpiDoc_XML/bgu/bgu.1/bgu.1.2.txt");
    File result = instance.getTextFile(collection, item);
    assertEquals(expResult, result);
  }

  /**
   * Test of getXmlFile method, of class FileUtils.
   */
  public void testGetXmlFile() {
    System.out.println("getXmlFile");
    String collection = "ddbdp";
    String item = "bgu;1;2";
    FileUtils instance = new FileUtils("/data/papyri.info/idp.data", "/data/papyri.info/pn/idp.html");
    File expResult = new File("/data/papyri.info/idp.data/DDB_EpiDoc_XML/bgu/bgu.1/bgu.1.2.xml");
    File result = instance.getXmlFile(collection, item);
    assertEquals(expResult, result);
  }

  /**
   * Test of findMatches method, of class FileUtils.
   */
  public void testFindMatches() {
    System.out.println("findMatches");
    String query = "ostrak*";
    String id = "http://papyri.info/ddbdp/o.heid;;123";
    FileUtils instance = new FileUtils("/data/papyri.info/idp.data", "/data/papyri.info/pn/idp.html");
    List<String> expResult = new ArrayList<String>();
    expResult.add("Ostrakon");
    List<String> result = instance.findMatches(query, id);
    int matches = 0;
    for (String r : result) {
      for (String e : expResult) {
        if (r.contains(e)) {
          matches++;
          break;
        }
      }
    }
    assertEquals(matches, expResult.size());
  }



}