/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package shopserverpkg;

import java.util.*;
import java.math.*;

/**
 *
 * @author Nathan
 */


public class RandomID {
    public long generate() {
        String idString = "";

        for (int i = 0; i < 10; i++) {
            idString += Math.round(Math.random() * 10);
        }

        return Long.parseLong(idString);
    }
}
