package com.websockets;

import java.io.StringWriter;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonWriter;

import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
//import jakarta.websocket.server.ServerEndpointConfig.Configurator;

@ServerEndpoint(value="/VitalCheckEndPoint",configurator=VitalCheckConfigurator.class)

public class VitalCheckEndPoint {
	static Set<Session> subscribers = Collections.synchronizedSet(new HashSet<Session>());
	
	@OnOpen
	public void handleOpen(Session user, EndpointConfig config) {
		user.getUserProperties().put("username", config.getUserProperties().get("username"));
		subscribers.add(user);
	}
	
	@OnMessage
	public void handleMessage(String message, Session user) {
		String username = (String) user.getUserProperties().get("username");
		
		if(!username.equals("doctor")) {
			String[] messages = message.split(",");
			
			subscribers.stream().forEach(x -> {
				try {
					if(messages[0].equals("btn")) {
						if(x.getUserProperties().get("username").equals("ambulance")) {
							x.getBasicRemote().sendText(buildJSON(username, messages[1]));
						}
					} else {
						if(x.getUserProperties().get("username").equals("doctor")) {
							x.getBasicRemote().sendText(buildJSON(username, messages[0] + "," + messages[1]));
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
		} else {
			String[] messages = message.split(",");
			String patient = messages[0];
			String subject = messages[1];
			
			subscribers.stream().forEach(x -> {
				try {
					if(subject.equals("ambulance")) {
						if(x.getUserProperties().get("username").equals(patient)) {
							x.getBasicRemote().sendText(buildJSON(messages[3], "N/A,Summoned an Ambulance"));
						} else if(x.getUserProperties().get("username").equals("ambulance")) {
							x.getBasicRemote().sendText(buildJSON(patient, messages[2]+",Requires an Ambulance"));
						} else if(x.getUserProperties().get("username").equals("doctor")) {
							x.getBasicRemote().sendText(buildJSON(patient, messages[2]));
						} 
					} else if(subject.equals("medication")) {
						if(x.getUserProperties().get("username").equals(patient)) {
							x.getBasicRemote().sendText(buildJSON(messages[4], messages[2] + "," + messages[3]));
						} else if(x.getUserProperties().get("username").equals("doctor")) {
							x.getBasicRemote().sendText(buildJSON(patient, messages[2]));
						} 
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
		}
	}
	
	private String buildJSON(String username, String message) {
		JsonObject jsonobject = Json.createObjectBuilder().add("message", username + "," + message).build();
		StringWriter stringwriter = new StringWriter();
		
		try(JsonWriter jsonwriter = Json.createWriter(stringwriter)) {
			jsonwriter.write(jsonobject);
		}
		
		return stringwriter.toString();
	}

	@OnClose
	public void handleClose(Session user) {
		subscribers.remove(user);
	}
	
	@OnError
	public void handleError(Throwable t) {
		
	}

}
