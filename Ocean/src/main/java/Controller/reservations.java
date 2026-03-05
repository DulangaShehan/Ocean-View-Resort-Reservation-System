package Controller;

import jakarta.servlet.RequestDispatcher;
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

import Daos.GuestDao;
import Daos.ReservationDao;
import Daos.RoomDao;
import Models.Guest;
import Models.Reservation;
import Models.Room;

/**
 * Servlet implementation class reservations
 */
@WebServlet("/reservations")
public class reservations extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public reservations() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
		if ("getGuestDetails".equals(action)) {
			handleGetGuestDetails(request, response);
		} else if ("getAvailableRooms".equals(action)) {
			handleGetAvailableRooms(request, response);
		} else if ("getGuests".equals(action)) {
			handleGetGuests(request, response);
		} else if ("saveReservation".equals(action)) {
			handleSaveReservation(request, response);
		} else if ("updateReservation".equals(action)) {
			handleUpdateReservation(request, response);
		} else if ("deleteReservation".equals(action)) {
			handleDeleteReservation(request, response);
		} else {
			// Default action: Load page with guests list
			loadPageWithGuests(request, response);
		}
	}

	private void loadPageWithGuests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
            GuestDao guestDao = new GuestDao();
            List<Guest> guests = guestDao.getAllGuestsByName(); // Using the one that orders by name ASC as per original SQL
			
			List<Map<String, String>> guestList = new ArrayList<>();
			for (Guest g : guests) {
				Map<String, String> guestMap = new HashMap<>();
				guestMap.put("id", String.valueOf(g.getId()));
				guestMap.put("name", g.getName());
				guestList.add(guestMap);
			}
			
			request.setAttribute("guestList", guestList);
			
			// Fetch Reservations
            ReservationDao reservationDao = new ReservationDao();
            List<Reservation> reservations = reservationDao.getAllReservationsWithRoomType();
            
			List<Map<String, String>> reservationList = new ArrayList<>();
            for (Reservation r : reservations) {
				Map<String, String> resMap = new HashMap<>();
				int resId = r.getId();
				resMap.put("id", String.valueOf(resId));
				resMap.put("display_id", "RES" + String.format("%03d", resId));
				resMap.put("name", r.getName());
				resMap.put("contact", r.getContact());
				
				int roomId = r.getRoomId();
				String roomNo = "R" + String.format("%03d", roomId);
				String roomType = r.getRoomType();
				resMap.put("room_display", roomNo + " - " + roomType);
				resMap.put("room_id", String.valueOf(roomId));
				resMap.put("room_no", roomNo); // For data attributes
				
				resMap.put("check_in", r.getCheckIn());
				resMap.put("check_out", r.getCheckOut());
				resMap.put("total_price", String.format("LKR %,.0f", r.getTotalPrice()));
				
				reservationList.add(resMap);
			}
			request.setAttribute("reservationList", reservationList);
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/Home/reservations.jsp");
			dispatcher.forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
			// Still forward to show page even if DB fails
			request.setAttribute("error", "Database connection error in reservations.loadPageWithGuests: " + e.getMessage());
			request.getRequestDispatcher("/Home/reservations.jsp").forward(request, response);
		}
	}

	private void handleGetGuestDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String guestId = request.getParameter("id");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		try {
            GuestDao guestDao = new GuestDao();
            Guest g = guestDao.getGuestById(Integer.parseInt(guestId));
			
			if (g != null) {
				// Manually building JSON to avoid dependency issues if Gson isn't there
				StringBuilder json = new StringBuilder();
				json.append("{");
				json.append("\"status\":\"success\",");
				json.append("\"name\":\"").append(escapeJson(g.getName())).append("\",");
				json.append("\"nic\":\"").append(escapeJson(g.getNic())).append("\",");
				json.append("\"address\":\"").append(escapeJson(g.getAddress())).append("\",");
				json.append("\"contact\":\"").append(escapeJson(g.getContact())).append("\"");
				json.append("}");
				out.print(json.toString());
			} else {
				out.print("{\"status\":\"error\",\"message\":\"Guest not found\"}");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			out.print("{\"status\":\"error\",\"message\":\"Database connection error in reservations.handleGetGuestDetails: " + e.getMessage() + "\"}");
		}
	}

	private void handleGetAvailableRooms(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		try {
            RoomDao roomDao = new RoomDao();
            List<Object[]> roomsWithDates = roomDao.getRoomsWithLatestBooking();
			
			StringBuilder json = new StringBuilder();
			json.append("[");
			boolean first = true;
            
            for (Object[] row : roomsWithDates) {
                Room r = (Room) row[0];
                String checkIn = (String) row[1];
                String checkOut = (String) row[2];
                
				if (!first) json.append(",");
				json.append("{");
				json.append("\"id\":").append(r.getId()).append(",");
				json.append("\"room_no\":\"R").append(String.format("%03d", r.getId())).append("\",");
				json.append("\"type\":\"").append(escapeJson(r.getRoomType())).append("\",");
				json.append("\"ac_type\":\"").append(escapeJson(r.getAcType())).append("\",");
				json.append("\"bed_type\":\"").append(escapeJson(r.getBedType())).append("\",");
				json.append("\"price\":").append(r.getOneNightPrice()).append(",");
				json.append("\"status\":\"").append(escapeJson(r.getStatus())).append("\",");
                // Add booking dates if available
                if (checkIn != null) json.append("\"booked_from\":\"").append(checkIn).append("\",");
                if (checkOut != null) json.append("\"booked_to\":\"").append(checkOut).append("\"");
                else if (checkIn != null) json.deleteCharAt(json.length() - 1); // Remove comma if only checkIn was added
                else json.deleteCharAt(json.length() - 1); // Remove comma after status
				json.append("}");
				first = false;
			}
			json.append("]");
			out.print(json.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Database connection error in reservations.handleGetAvailableRooms: " + e.getMessage());
			out.print("[]");
		}
	}

	private void handleGetGuests(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		try {
            GuestDao guestDao = new GuestDao();
            List<Guest> guests = guestDao.getAllGuestsByName();
			
			StringBuilder json = new StringBuilder();
			json.append("[");
			boolean first = true;
			for (Guest g : guests) {
				if (!first) json.append(",");
				json.append("{");
				json.append("\"id\":").append(g.getId()).append(",");
				json.append("\"name\":\"").append(escapeJson(g.getName())).append("\"");
				json.append("}");
				first = false;
			}
			json.append("]");
			out.print(json.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Database connection error in reservations.handleGetGuests: " + e.getMessage());
			out.print("[]");
		}
	}

	private void handleSaveReservation(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		String name = request.getParameter("name");
		String contact = request.getParameter("contact");
		String nic = request.getParameter("nic");
		String address = request.getParameter("address");
		String roomIdStr = request.getParameter("room_id");
		String checkInStr = request.getParameter("check_in");
		String checkOutStr = request.getParameter("check_out");
		
		try {
            ReservationDao reservationDao = new ReservationDao();
            
            Guest guest = new Guest();
            guest.setName(name);
            guest.setContact(contact);
            guest.setNic(nic);
            guest.setAddress(address);
            
            Reservation res = new Reservation();
            res.setName(name);
            res.setContact(contact);
            res.setRoomId(Integer.parseInt(roomIdStr));
            res.setCheckIn(checkInStr);
            res.setCheckOut(checkOutStr);
            
            reservationDao.saveReservation(res, guest);
            
			out.print("{\"status\":\"success\",\"message\":\"Reservation saved successfully\"}");
			
		} catch (Exception e) {
			e.printStackTrace();
			out.print("{\"status\":\"error\",\"message\":\"Database connection error in reservations.handleSaveReservation: " + e.getMessage() + "\"}");
		}
	}

	private void handleUpdateReservation(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String contact = request.getParameter("contact");
		String checkInStr = request.getParameter("check_in");
		String checkOutStr = request.getParameter("check_out");
		
		try {
            ReservationDao reservationDao = new ReservationDao();
            
            Reservation res = new Reservation();
            res.setId(Integer.parseInt(id));
            res.setName(name);
            res.setContact(contact);
            res.setCheckIn(checkInStr);
            res.setCheckOut(checkOutStr);
            
            reservationDao.updateReservation(res);
            
			out.print("{\"status\":\"success\",\"message\":\"Reservation updated successfully\"}");
			
		} catch (Exception e) {
			e.printStackTrace();
			out.print("{\"status\":\"error\",\"message\":\"Database connection error in reservations.handleUpdateReservation: " + e.getMessage() + "\"}");
		}
	}

	private void handleDeleteReservation(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		String id = request.getParameter("id");
		
		try {
            ReservationDao reservationDao = new ReservationDao();
            reservationDao.deleteReservation(Integer.parseInt(id));
            
			out.print("{\"status\":\"success\",\"message\":\"Reservation deleted successfully\"}");
			
		} catch (Exception e) {
			e.printStackTrace();
			out.print("{\"status\":\"error\",\"message\":\"Database connection error in reservations.handleDeleteReservation: " + e.getMessage() + "\"}");
		}
	}

	private String escapeJson(String input) {
		if (input == null) return "";
		return input.replace("\\", "\\\\")
		            .replace("\"", "\\\"")
		            .replace("\n", "\\n")
		            .replace("\r", "\\r")
		            .replace("\t", "\\t");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
