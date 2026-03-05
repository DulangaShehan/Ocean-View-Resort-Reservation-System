package Controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Daos.BillingDao;
import Models.Bill;

/**
 * Servlet implementation class billing
 */
@WebServlet("/billing")
public class billing extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public billing() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Map<String, String>> billingList = new ArrayList<>();
		
		try {
            BillingDao billingDao = new BillingDao();
            List<Bill> bills = billingDao.getAllBillsWithDetails();
			
			for (Bill b : bills) {
				Map<String, String> billMap = new HashMap<>();
				int bId = b.getId();
				int resId = b.getResId();
				
				// Format IDs (Invoice ID matches Reservation ID logic as requested)
				billMap.put("raw_id", String.valueOf(bId));
				billMap.put("b_id", "INV" + String.format("%03d", resId)); // Invoice # follows Res #
				billMap.put("b_res_id", "RES" + String.format("%03d", resId));
				
				billMap.put("b_name", b.getName());
				billMap.put("b_night", b.getNight());
				
				// Extra details for Modal
				billMap.put("res_contact", b.getResContact() != null ? b.getResContact() : "N/A");
				billMap.put("res_check_in", b.getResCheckIn() != null ? b.getResCheckIn() : "-");
				billMap.put("res_check_out", b.getResCheckOut() != null ? b.getResCheckOut() : "-");
				
				int roomId = b.getResRoomId();
				billMap.put("res_room_id", "R" + String.format("%03d", roomId));
				
				// Format prices with currency
				double nightPrice = b.getNightPrice();
				billMap.put("b_night_price", String.format("LKR %,.0f", nightPrice));
				
				double totalPrice = b.getTotalPrice();
				billMap.put("b_total_price", String.format("LKR %,.0f", totalPrice));
				
				billMap.put("b_status", b.getStatus());
				
				billingList.add(billMap);
			}
			
			request.setAttribute("billingList", billingList);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/Home/billing.jsp");
			dispatcher.forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error: " + e.getMessage());
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
		if ("checkout".equals(action)) {
			handleCheckout(request, response);
		} else {
			doGet(request, response);
		}
	}
	
	private void handleCheckout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		String billingIdStr = request.getParameter("b_id"); // The DB ID, e.g. "5"
		
		try {
            BillingDao billingDao = new BillingDao();
            billingDao.checkout(Integer.parseInt(billingIdStr));
            
			response.getWriter().write("{\"status\":\"success\", \"message\":\"Checkout completed successfully\"}");
			
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
		}
	}

}
