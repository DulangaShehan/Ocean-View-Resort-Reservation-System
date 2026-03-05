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
import Utils.DBCon;

/**
 * Servlet implementation class guests
 */
@WebServlet("/guests")
public class guests extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public guests() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Map<String, String>> guestList = new ArrayList<>();
		
		try {
			Daos.GuestDao guestDao = new Daos.GuestDao();
			List<Models.Guest> guests = guestDao.getAllGuests();
			
			for (Models.Guest g : guests) {
				Map<String, String> guestMap = new HashMap<>();
				int id = g.getId();
				guestMap.put("id", String.valueOf(id));
				guestMap.put("formattedId", String.format("G%03d", id));
				guestMap.put("name", g.getName() != null ? g.getName() : "");
				guestMap.put("address", g.getAddress() != null ? g.getAddress() : "");
				guestMap.put("nic", g.getNic() != null ? g.getNic() : "");
				guestMap.put("contact", g.getContact() != null ? g.getContact() : "");
				guestList.add(guestMap);
			}
			
			request.setAttribute("guestList", guestList);
			System.out.println("Guests Servlet: Forwarding to /Home/guests.jsp");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/Home/guests.jsp");
			dispatcher.forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
			// Forward even if empty/error to show the page
			request.setAttribute("guestList", guestList);
			request.getRequestDispatcher("/Home/guests.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		
		String action = request.getParameter("action");
		if (action == null) action = "add"; // Default to add
		
		try {
			Daos.GuestDao guestDao = new Daos.GuestDao();
			boolean success = false;
			String message = "Operation failed";
			
			if ("add".equals(action)) {
				String name = request.getParameter("name");
				String address = request.getParameter("address");
				String nic = request.getParameter("nic");
				String contact = request.getParameter("contact");
				
				if (name == null || name.trim().isEmpty()) {
					out.print("{\"status\": \"error\", \"message\": \"Name is required.\"}");
					return;
				}
				
				Models.Guest guest = new Models.Guest();
				guest.setName(name);
				guest.setAddress(address);
				guest.setNic(nic);
				guest.setContact(contact);
				
				success = guestDao.addGuest(guest);
				message = success ? "Guest added successfully!" : "Failed to add guest.";
				
			} else if ("update".equals(action)) {
				String id = request.getParameter("id");
				String name = request.getParameter("name");
				String address = request.getParameter("address");
				String nic = request.getParameter("nic");
				String contact = request.getParameter("contact");
				
				if (id == null || id.trim().isEmpty()) {
					out.print("{\"status\": \"error\", \"message\": \"Guest ID is missing.\"}");
					return;
				}
				
				if (name == null || name.trim().isEmpty()) {
					out.print("{\"status\": \"error\", \"message\": \"Name is required.\"}");
					return;
				}
				
				Models.Guest guest = new Models.Guest();
				guest.setId(Integer.parseInt(id));
				guest.setName(name);
				guest.setAddress(address);
				guest.setNic(nic);
				guest.setContact(contact);
				
				success = guestDao.updateGuest(guest);
				message = success ? "Guest updated successfully!" : "Failed to update guest.";
				
			} else if ("delete".equals(action)) {
				String id = request.getParameter("id");
				
				if (id == null || id.trim().isEmpty()) {
					out.print("{\"status\": \"error\", \"message\": \"Guest ID is missing.\"}");
					return;
				}
				
				success = guestDao.deleteGuest(Integer.parseInt(id));
				message = success ? "Guest deleted successfully!" : "Failed to delete guest.";
			}
			
			if (success) {
				out.print("{\"status\": \"success\", \"message\": \"" + message + "\"}");
			} else {
				out.print("{\"status\": \"error\", \"message\": \"" + message + "\"}");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			String errorMsg = e.getMessage() != null ? e.getMessage() : "Unknown error occurred";
			out.print("{\"status\": \"error\", \"message\": \"Error: " + errorMsg.replace("\"", "\\\"") + "\"}");
		}
	}
}
