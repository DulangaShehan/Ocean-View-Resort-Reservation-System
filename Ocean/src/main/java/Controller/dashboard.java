package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import Daos.GuestDao;
import Daos.RoomDao;

/**
 * Servlet implementation class dashboard
 */
@WebServlet("/dashboard")
public class dashboard extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public dashboard() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int guestCount = 0;
		int roomCount = 0;

		try {
            GuestDao guestDao = new GuestDao();
            guestCount = guestDao.getGuestCount();

            RoomDao roomDao = new RoomDao();
            roomCount = roomDao.getRoomCount();
            
		} catch (Exception e) {
			e.printStackTrace();
		}

		request.setAttribute("guestCount", guestCount);
		request.setAttribute("roomCount", roomCount);
		request.getRequestDispatcher("/Home/dashboard.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
