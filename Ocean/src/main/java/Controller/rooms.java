package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import Utils.DBCon;

/**
 * Servlet implementation class rooms
 */
@WebServlet("/rooms")
public class rooms extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public rooms() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("filter".equals(action)) {
            handleFilterRooms(request, response);
            return;
        }

        List<Map<String, Object>> roomsList = new ArrayList<>();

        try {
            Daos.RoomDao roomDao = new Daos.RoomDao();
            List<Models.Room> rooms = roomDao.getAllRooms();
            
            for (Models.Room r : rooms) {
                Map<String, Object> room = new HashMap<>();
                room.put("r_id", r.getId());
                room.put("r_room_type", r.getRoomType());
                room.put("r_ac_type", r.getAcType());
                room.put("r_bed_type", r.getBedType());
                room.put("r_view", r.getView());
                room.put("r_max_members", r.getMaxMembers());
                room.put("r_status", r.getStatus());
                room.put("r_one_night_price", r.getOneNightPrice());
                roomsList.add(room);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database connection error in rooms.doGet: " + e.getMessage());
        }

        request.setAttribute("roomsList", roomsList);
        request.getRequestDispatcher("/Home/rooms.jsp").forward(request, response);
    }

    /**
     * Handle filtering of rooms by date
     */
    private void handleFilterRooms(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            Daos.RoomDao roomDao = new Daos.RoomDao();
            List<Models.Room> rooms = roomDao.getAvailableRooms(checkIn, checkOut);
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < rooms.size(); i++) {
                Models.Room r = rooms.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"r_id\":").append(r.getId()).append(",");
                json.append("\"r_room_type\":\"").append(r.getRoomType()).append("\",");
                json.append("\"r_bed_type\":\"").append(r.getBedType()).append("\",");
                json.append("\"r_ac_type\":\"").append(r.getAcType()).append("\",");
                json.append("\"r_max_members\":").append(r.getMaxMembers()).append(",");
                json.append("\"r_view\":\"").append(r.getView()).append("\",");
                json.append("\"r_status\":\"").append(r.getStatus()).append("\",");
                json.append("\"r_one_night_price\":").append(r.getOneNightPrice());
                json.append("}");
            }
            json.append("]");
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
        out.flush();
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Check for role-based permission
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        Integer roleId = (session != null) ? (Integer) session.getAttribute("role_id") : null;
        
        if (roleId == null || roleId != 1) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"status\":\"error\", \"message\":\"Unauthorized: You do not have permission to perform this action.\"}");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            Daos.RoomDao roomDao = new Daos.RoomDao();
            boolean success = false;
            String message = "Operation failed";

            if ("delete".equals(action)) {
                String idStr = request.getParameter("r_id");
                if (idStr == null) throw new IllegalArgumentException("Room ID is required for deletion.");
                
                int rId = Integer.parseInt(idStr);
                success = roomDao.deleteRoom(rId);
                message = success ? "Room deleted successfully!" : "Failed to delete room.";
                
            } else if ("update".equals(action)) {
                String idStr = request.getParameter("r_id");
                String roomType = request.getParameter("roomType");
                String bedType = request.getParameter("bedType");
                String acType = request.getParameter("acType");
                String maxOccupancyStr = request.getParameter("maxOccupancy");
                String view = request.getParameter("view");
                String priceStr = request.getParameter("price");
                
                int rId = Integer.parseInt(idStr);
                int maxOccupancy = Integer.parseInt(maxOccupancyStr);
                double price = Double.parseDouble(priceStr);
                
                Models.Room room = new Models.Room();
                room.setId(rId);
                room.setRoomType(roomType);
                room.setAcType(acType);
                room.setBedType(bedType);
                room.setView(view);
                room.setMaxMembers(maxOccupancy);
                room.setOneNightPrice(price);
                
                success = roomDao.updateRoom(room);
                message = success ? "Room updated successfully!" : "Failed to update room.";
                
            } else {
                // Add Room (Default)
                String roomType = request.getParameter("roomType");
                String bedType = request.getParameter("bedType");
                String acType = request.getParameter("acType");
                String maxOccupancyStr = request.getParameter("maxOccupancy");
                String view = request.getParameter("view");
                String priceStr = request.getParameter("price");
                
                if (roomType == null || bedType == null || acType == null || 
                    maxOccupancyStr == null || view == null || priceStr == null) {
                    throw new IllegalArgumentException("All fields are required.");
                }
                
                int maxOccupancy = Integer.parseInt(maxOccupancyStr);
                double price = Double.parseDouble(priceStr);
                
                Models.Room room = new Models.Room();
                room.setRoomType(roomType);
                room.setAcType(acType);
                room.setBedType(bedType);
                room.setView(view);
                room.setMaxMembers(maxOccupancy);
                room.setOneNightPrice(price);
                
                success = roomDao.addRoom(room);
                message = success ? "Room added successfully!" : "Failed to add room.";
            }
            
            if (success) {
                out.print("{\"status\":\"success\", \"message\":\"" + message + "\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"" + message + "\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"Invalid number format.\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Database connection error in rooms.doPost: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
