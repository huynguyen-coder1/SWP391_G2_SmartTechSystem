<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    List<Map<String,Object>> orders = (List<Map<String,Object>>) request.getAttribute("orders");
%>

<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>Order ID</th>
            <th>User</th>
            <th>Total Amount</th>
            <th>Status</th>
            <th>Order Date</th>
            <th>Shipper</th>
        </tr>
    </thead>
    <tbody>
    <% if (orders != null) {
        for (Map<String,Object> o : orders) { %>
            <tr>
                <td><%= o.get("Id") %></td>
                <td><%= o.get("FullName") %></td>
                <td><%= o.get("TotalAmount") %></td>
                <td>
                    <% 
                        int status = (int) o.get("Status");
                        switch(status){
                            case 0: out.print("Pending"); break;
                            case 1: out.print("Paid"); break;
                            case 2: out.print("Shipping"); break;
                            case 3: out.print("Completed"); break;
                            case 4: out.print("Canceled"); break;
                        }
                    %>
                </td>
                <td><%= o.get("OrderDate") %></td>
                <td><%= o.get("ShipperId") %></td>
            </tr>
    <%  } 
       } %>
    </tbody>
</table>
