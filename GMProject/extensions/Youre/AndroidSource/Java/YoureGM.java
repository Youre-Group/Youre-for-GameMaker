package com.company.game;
import com.company.game.R;
import com.yoyogames.runner.RunnerJNILib;

import android.app.Activity;

import android.util.Log;

public class YoureGM
{
	private static final int EVENT_OTHER_SOCIAL = 70;
	
	public YoureGM() 
	{
	}
	
	public String getCodeChallenge(String codeVerifier)
	{
		return generateCodeChallange(codeVerifier);
	}
	
	private String generateCodeChallange(String codeVerifier)  {
	    byte[] bytes = codeVerifier.getBytes("US-ASCII");
	    MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
	    messageDigest.update(bytes, 0, bytes.length);
	    byte[] digest = messageDigest.digest();
	    return Base64.getUrlEncoder().withoutPadding().encodeToString(digest);
	}
}



