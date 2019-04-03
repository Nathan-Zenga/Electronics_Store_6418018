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
public class Product {
    private float id;
    private String name;
    private float price;
    private int quantity;
    private int stock_quantity;
    private String type;

    public Product(float id, String name, float price, int quantity, String type) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.type = type;
        this.quantity = quantity;
        this.stock_quantity = stock_quantity;
    }

    /**
     * @return the name
     */
    public float getID() {
        return id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the product name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the price
     */
    public float getPrice() {
        return price;
    }

    /**
     * @param price
     */
    public void setPrice(float price) {
        this.price = price;
    }
    
    /**
     * @return the quantity
     */
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    /**
     * @return the product type / category
     */
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setStockQuantity(String stock_quantity) {
        this.stock_quantity = stock_quantity;
    }

    public int getStockQuantity() {
        return stock_quantity;
    }
}
