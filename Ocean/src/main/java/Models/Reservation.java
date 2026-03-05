package Models;

public class Reservation {
    private int id;
    private String name;
    private String contact;
    private int roomId;
    private String checkIn;
    private String checkOut;
    private String dates;
    private double nightPrice;
    private double totalPrice;
    
    // Additional fields for display/joins
    private String roomType;

    public Reservation() {}

    public Reservation(int id, String name, String contact, int roomId, String checkIn, String checkOut, String dates, double nightPrice, double totalPrice) {
        this.id = id;
        this.name = name;
        this.contact = contact;
        this.roomId = roomId;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.dates = dates;
        this.nightPrice = nightPrice;
        this.totalPrice = totalPrice;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }

    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }

    public String getDates() { return dates; }
    public void setDates(String dates) { this.dates = dates; }

    public double getNightPrice() { return nightPrice; }
    public void setNightPrice(double nightPrice) { this.nightPrice = nightPrice; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
}
