/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package shopserverpkg;

/**
 *
 * @author Nathan
 */
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import javax.servlet.http.HttpServletRequest;

public class ImageDownloader {
    public boolean save(HttpServletRequest request, String src, String newFilename) throws IOException {
        BufferedImage img = null;
        String rootPath = request.getSession().getServletContext().getRealPath("/img/");
        String ext = src.contains(".png") || src.contains(".PNG") ? "png" : "jpg";
        boolean complete;

        newFilename = rootPath + "/" + newFilename + "." + ext;
        System.out.println(newFilename);

        try {
            URL url = new URL(src);
            img = ImageIO.read(url);
            ImageIO.write(img, ext, new File(newFilename));
            complete = true;

        } catch(IOException e) {
            complete = false;
            e.printStackTrace();
        }
        return complete;
    }
}