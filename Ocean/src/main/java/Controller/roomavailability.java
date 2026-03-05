package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Set;

import Daos.ReservationDao;

/**
 * Servlet implementation class roomavailability
 */
@WebServlet("/roomavailability")
public class roomavailability extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public roomavailability() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String roomIdStr = request.getParameter("roomId");
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");

        if (roomIdStr == null || monthStr == null || yearStr == null) {
            out.print("{\"error\": \"Missing parameters\"}");
            return;
        }

        int roomId;
        int month;
        int year;

        try {
            roomId = Integer.parseInt(roomIdStr);
            month = Integer.parseInt(monthStr); 
            year = Integer.parseInt(yearStr);
        } catch (NumberFormatException e) {
            out.print("{\"error\": \"Invalid parameters\"}");
            return;
        }

        try {
            ReservationDao reservationDao = new ReservationDao();
            Set<String> bookedDates = reservationDao.getBookedDates(roomId, month, year);

            // Build JSON response
            StringBuilder json = new StringBuilder();
            json.append("[");
            boolean first = true;
            for (String date : bookedDates) {
                if (!first) json.append(",");
                json.append("\"").append(date).append("\"");
                first = false;
            }
            json.append("]");
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Database connection error in roomavailability.doGet: " + e.getMessage() + "\"}");
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
