package Models;

public class Room {
    private int id;
    private String roomType;
    private String acType;
    private String bedType;
    private String view;
    private int maxMembers;
    private String status;
    private double oneNightPrice;

    public Room() {}

    public Room(int id, String roomType, String acType, String bedType, String view, int maxMembers, String status, double oneNightPrice) {
        this.id = id;
        this.roomType = roomType;
        this.acType = acType;
        this.bedType = bedType;
        this.view = view;
        this.maxMembers = maxMembers;
        this.status = status;
        this.oneNightPrice = oneNightPrice;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getAcType() { return acType; }
    public void setAcType(String acType) { this.acType = acType; }

    public String getBedType() { return bedType; }
    public void setBedType(String bedType) { this.bedType = bedType; }

    public String getView() { return view; }
    public void setView(String view) { this.view = view; }

    public int getMaxMembers() { return maxMembers; }
    public void setMaxMembers(int maxMembers) { this.maxMembers = maxMembers; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getOneNightPrice() { return oneNightPrice; }
    public void setOneNightPrice(double oneNightPrice) { this.oneNightPrice = oneNightPrice; }
}
