package Models;

public class Bill {
    private int id;
    private String name;
    private int resId;
    private String night;
    private double nightPrice;
    private double totalPrice;
    private String status;

    // Additional fields for display
    private String resContact;
    private String resCheckIn;
    private String resCheckOut;
    private int resRoomId;

    public Bill() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getResId() { return resId; }
    public void setResId(int resId) { this.resId = resId; }

    public String getNight() { return night; }
    public void setNight(String night) { this.night = night; }

    public double getNightPrice() { return nightPrice; }
    public void setNightPrice(double nightPrice) { this.nightPrice = nightPrice; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResContact() { return resContact; }
    public void setResContact(String resContact) { this.resContact = resContact; }

    public String getResCheckIn() { return resCheckIn; }
    public void setResCheckIn(String resCheckIn) { this.resCheckIn = resCheckIn; }

    public String getResCheckOut() { return resCheckOut; }
    public void setResCheckOut(String resCheckOut) { this.resCheckOut = resCheckOut; }

    public int getResRoomId() { return resRoomId; }
    public void setResRoomId(int resRoomId) { this.resRoomId = resRoomId; }
}
