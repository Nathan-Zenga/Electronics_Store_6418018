/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package shopserverpkg;

import org.junit.Test;
import static org.junit.Assert.*;
import javax.servlet.http.HttpServletRequest;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;

/**
 *
 * @author Nathan
 */
public class ImageDownloaderTest {
    
    public ImageDownloaderTest() {
    }

    @BeforeClass
    public static void setUpClass() throws Exception {
    }

    @AfterClass
    public static void tearDownClass() throws Exception {
    }

    @Before
    public void setUp() throws Exception {
    }

    @After
    public void tearDown() throws Exception {
    }

    /**
     * Test of save method, of class ImageDownloader.
     */
    @Test
    public void testSave() throws Exception {
        HttpServletRequest req = null;
        String src = "";
        String newFilename = "";
        boolean expResult = false;
        boolean actualResult = new ImageDownloader().save(req, src, newFilename);
        assertEquals(expResult, actualResult);
    }
    
}
