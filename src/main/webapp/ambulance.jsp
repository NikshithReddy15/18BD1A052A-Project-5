<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
    <head>
        <title>Ambulance Page</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body class="hold-transition">

        <header class="card notranslate" id="topnav">
            <nav id="navbar_top" class="navbar navbar-expand-lg navbar-dark bg-success">
                <div class="container">
                    <a class="navbar-brand" href="localhost:8080/Project_-_5_Hospital_Inpatient_Service" style="padding-right: 60%;">Tracker</a>
                </div>
            </nav>
        </header>

        <div class="card content-body bg-light border-none" style="margin: 2%; margin-left: 2%;">
            <div class="card-body table-responsive" style="text-align: center;">
                <label id="ambname"></label>
            </div>
        </div>

        <div class="card content-body bg-light border-none" style="margin: 2%; margin-left: 2%;">
            <div class="card-body table-responsive p-0" style="min-height: 400px;">
                <table class="table table-striped table-bordered table-head-fixed text-nowrap" id="detailstable">
                    <thead>
                        <tr>
                            <th style="width: 10%" >Patient Name</th>
                            <th style="width: 10%" >Contact</th>
                            <th style="width: 10%" >Deployment Status</th>
                        </tr>
                    </thead>
                    <tbody id="detailstable1">
                        <!-- <tr> -->
                            <!-- Ambulance dashboard data -->
                        <!-- </tr> -->
                    </tbody>
                </table>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    </body>

    <script>

	    var url = new URL(window.location.href);
	    document.getElementById("ambname").innerHTML = '<b>Ambulance Provider : '+url.searchParams.get("username")+'</b>';
	    
        var websocket = new WebSocket("ws://localhost:8080/Project_-_5_Hospital_Inpatient_Service/VitalCheckEndPoint");
        websocket.onmessage = function processMessage(message) {
            var jsondata = JSON.parse(message.data);
            if(jsondata.message != null) {
                var details = jsondata.message.split(",");
            	if(details.length > 2) {
            		if(!document.getElementById("row"+details[0]+"statusbtn")) {
		                var row = document.getElementById("detailstable1");
		                row.innerHTML = '<tr id="row'+details[0]+'statusbtn"><td>'+details[0]+'</td><td>'+details[1]+'</td><td><input type="button" value="Deploy" id="'+details[0]+'statusbtn" class=\'btn btn-sm btn-info\' onclick="changeStatus('+details[0]+'statusbtn);"></td></tr>' + row.innerHTML;
		                alert(details[0]+" Requires an Ambulance");
            		} else {
            			alert(details[0]+" Re-requested for an ambulance");
            		}
            	} else {
            		//document.getElementById(details[1]).disabled = true;
            		document.getElementById("row"+details[1]+"").innerHTML="";
            	}
            }
        }
        
        function changeStatus(id) {
        	//document.getElementById(id.id).disabled = true;
        	alert("Ambulance Deployed");
        	websocket.send("btn,"+id.id);
        }

    </script>

</html>
